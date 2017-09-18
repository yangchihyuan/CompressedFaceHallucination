%Chih-Yuan Yang
%Test13 1/27/15 I need to correct Sifei's algorithm by generating landmarks from compressed inputs
%Test53 7/28/15 I think Sifei's reported PSNR and SSIM values in her CVPR14 draft is wrong because
%she uses the landmarks localized from high-quality images. I keep Test13 unchanged and verify
%the suspection in Test53
%Test54 7/30/2015 I replace the localization method of Sifei's ICIP algorithm to check the influence of
%performance and execution time.
%Test56 7/30/2015 I further test the influence of 2-point alignment in terms of numerical evaluations
%and execution time.
%Test57 7/30/2015 I replace the YCbCr color space of compared patches with Y channel only.
%I remove the image alignment for PatchMatch. I correct the wrong Y example sources in Test46.
%The generated numerical evaluations are ok, and the 30 to 40 seconds of execution time are reduced.
%Test58 7/30/2015 I am wondering whether parfor can further reduce the execution time.
%Test59 7/31/2015 I am wondering whether the execution time can be reduced if the JPEG compression
%is removed from F4b
%Test60 7/31/2015 I reduce beta0 to 0.02 from 0.2 to see whether I can improve the PSNR and SSIM values.
%But I get worse values.
%Test61 7/31/2015 I try a large beta0, the values are better.
%Test62 7/31/2015 I try a small beta1, the values are even better.
%Test73 5/25/2016 I try SA-DCT to replace Sifei's code to handle texture.
%Test77 5/28/2016 I want to run every face in the JANUSProposal 25.jpg 
%Test80 6/6/2016 I have to re-run the experiment because the code looks
%ugly (make a region black to find another face). In addition, I also want
%to disregard the function T1_Facesmoother(). I also want to see the
%results of using the full Multi-PIE dataset, so that I will no longer load
%Sifei's prepared mat files.
%Test82 6/9/2016 I want to automatically determine the illumination.
clc
clear
close all

option_generate_a_figure_with_localized_landmarks = true;

folder_Ours = pwd;
folder_Code = fileparts(folder_Ours);
folder_Lib = fullfile(folder_Code,'Lib');
folder_UCIFaceDetection = fullfile(folder_Lib,'UCIFaceDetection');
folder_intraface = fullfile(folder_Lib,'FacialFeatureDetection&Tracking_v1.3');
folder_models = fullfile(folder_intraface,'models');

if ispc
    folder_save = fullfile('Result',mfilename);
    folder_multipie = fullfile(fileparts(folder_Code),'Dataset','Multi-PIE');    
elseif isunix
    folder_save = fullfile('/home/chihyuan/mnt/Chih-Yuan-PC/120801SRForFace/Code/Ours2','Result',mfilename);
end
folder_filelist = 'FileList';

addpath(folder_UCIFaceDetection);
addpath(fullfile(folder_Lib, 'SA_DCT_Demobox_v143'));
addpath(fullfile(folder_Lib, 'Timofte13'));

scalingfactor = 4;
Gau_sigma = 1.6;

idx_file_start = 1;
idx_file_end = 'all';

test_setting{1}.fn_filelist = 'UMassSoccer.txt';
test_setting{1}.folder_test = fullfile('Source','InternetDownload','UMassSoccer');
test_setting{1}.landmark_algorithm = 2;         %2 means to use OpenCV to detect faces.

test_setting{2}.fn_filelist = 'XMen.txt';
test_setting{2}.folder_test = fullfile('Source','InternetDownload','XMen');
test_setting{2}.landmark_algorithm = 2;         %2 means to use OpenCV to detect faces.

test_setting{3}.fn_filelist = 'XMen.txt';
test_setting{3}.folder_test = fullfile('Source','InternetDownload','XMen');
test_setting{3}.landmark_algorithm = 3;
test_setting{3}.indices_of_face = [16 17];

test_setting{4}.fn_filelist = 'FivePresidents.txt';
test_setting{4}.folder_test = fullfile('Source','InternetDownload','FivePresidents');
test_setting{4}.landmark_algorithm = 3;         %3 means to load prepared face rectangle.
test_setting{4}.indices_of_face = 1:5;

test_setting{5}.fn_filelist = 'PubFigWorkSet100_Sorted_new_1_to_4.txt';
test_setting{5}.folder_test = fullfile('Source','PubFigAdequate','input');
test_setting{5}.landmark_algorithm = 4;         %4 means not using OpenCV
test_setting{5}.indices_of_face = 1;

U22_makeifnotexist(folder_save);
string_test_number = mfilename;
array_underline = strfind(string_test_number , '_');
string_test_number = string_test_number(1:array_underline(1)-1);
str_legend = string_test_number;

dictionarysize = 4096;
conf = F1_LoadConfig(scalingfactor,dictionarysize);
extend_width_lr = 1;
extend_with_hr = extend_width_lr * scalingfactor;

example = struct('filename',[],'landmark',[], 'bglass',[]);
glass_table = U30_LoadGlassTable(fullfile('Result','PP26_CheckGlassTable','glass_table.txt'));
for idx_test_setting = 1:4
    fn_filelist = test_setting{idx_test_setting}.fn_filelist;
    landmark_algorithm = test_setting{idx_test_setting}.landmark_algorithm;
    arr_filename = U5_ReadFileNameList(fullfile(folder_filelist,fn_filelist));
    num_file = length(arr_filename);
    if isa(idx_file_end,'char')
        if strcmp(idx_file_end,'all')
            idx_file_end = num_file;
        end
    end

    switch landmark_algorithm
        case 1
            string_localization_algorithm = 'UCI';
            addpath(fullfile(folder_Lib,'UCIFaceDetection'));
        case {2 ,4}
            if ispc
                string_localization_algorithm = 'IntraFace';
                addpath(genpath(folder_intraface));     %I need to add this path, otherwise a mexw64 file can not be loaded
                %setup the IntraFace detector
                option.face_score = 0.3;
                option.min_neighbors = 4;       %The original setting is 2 and only one
                option.min_face_size = [25 25];   %[50 50] is the original setting
                option.compute_pose = true;
                %xml_file = fullfile(folder_models,'haarcascade_frontalface_alt2.xml');
                xml_file = fullfile(folder_models,'haarcascade_frontalface_default.xml');
                % load tracking model
                load(fullfile(folder_models,'TrackingModel-xxsift-v1.10.mat'));
                % load detection model
                load(fullfile(folder_models,'DetectionModel-xxsift-v1.5.mat'));
                % create face detector handle
                fd_h = cv.CascadeClassifier(xml_file);      %This statement does not work on Linux
                DM{1}.fd_h = fd_h;
            else
                error('IntraFace only runs on Windows');
            end
        case 3
            string_localization_algorithm = 'Interactive';
    end
    
    for fileidx=idx_file_start:idx_file_end
        %open specific file
        fn_test = arr_filename{fileidx};
        fn_short = fn_test(1:end-4);
        fprintf('working %s\n',fn_test);
        fn_log = fullfile(folder_save,sprintf('%s_log.txt',fn_short));
        [status, cmdout] = system('hostname');
        U3a_log(fn_log, cmdout(1:end-1));    %record the computer name.
        U3a_log(fn_log, string_test_number);

        img.raw = imread(fullfile(test_setting{idx_test_setting}.folder_test,fn_test));
        img.deblocked = F55_SADCT_deblock(fullfile(test_setting{idx_test_setting}.folder_test,fn_test));   %The output class is double
        img.deblocked_ui8 = im2uint8(img.deblocked);
        %Use OpenCV to detect faces.
        switch landmark_algorithm
            case 2
                faces = DM{1}.fd_h.detect(img.deblocked_ui8,'MinNeighbors',option.min_neighbors,...
                    'ScaleFactor',1.2,'MinSize',option.min_face_size);
                indices_of_faces = 1:length(faces);
            case 3
                indices_of_faces = test_setting{idx_test_setting}.indices_of_face;
%            imshow(img.deblocked); hold on;
            case 4
                indices_of_faces = [1];
        end
        
        for idx_face = indices_of_faces
            switch landmark_algorithm
                case 2
                    output = xx_track_detect(DM,TM,img.deblocked_ui8,faces{idx_face},option);
                    if ~isempty(output.pred)
%                        plot(output.pred(:,1),output.pred(:,2),'g*','markersize',2); 
                    else
                        fprintf('idx_face %d does not localize landmarks.\n',idx_face);
                        continue;
                    end
                case 3
                    folder_landmark_test_image = folder_save;
                    loaddata = load(fullfile(test_setting{idx_test_setting}.folder_test, sprintf('%d.mat',idx_face)));
                    output = loaddata.output;
                case 4
                    output = xx_track_detect(DM,TM,img.deblocked_ui8,[],option);
                    if ~isempty(output.pred)
%                        plot(output.pred(:,1),output.pred(:,2),'g*','markersize',2); 
                    else
                        fprintf('%s idx_face %d does not localize landmarks.\n',fn_test, idx_face);
                        U3a_log(fn_log, sprintf('%s does not return landmarks',fn_test));
                        continue;
                    end
            end
            landmark.test_image_lr.intraface = output.pred;
            fn_save = sprintf('%s_%d_%s.png',fn_short,idx_face,str_legend);
            fn_landmark_test = sprintf('%s_landmark_IntraFace.mat',fn_short);
            landmark.test_image_lr.multipie = F1d_ConvertLandmark_Intraface_to_MultiPie_66points(landmark.test_image_lr.intraface);
            [landmark.test_image_lr.eye_center, eye_distance_lr] = F57_EyeCenterFromLandmarks(landmark.test_image_lr.multipie);
            %the left, right, top, bottom are all pixel indices.
            left_lr = round( landmark.test_image_lr.eye_center(1) - 30 + 0.5);
            right_lr = left_lr + 60 - 1;
            top_lr = round( landmark.test_image_lr.eye_center(2) - 40 + 0.5);
            bottom_lr = top_lr + 80 - 1;

            %A face may be close to a boundary and unable to crop
            switch landmark_algorithm
                case 2 %consider the bounary problem only when OpenCV is used.
                    if top_lr >=1 && bottom_lr <= size(img.deblocked,1) && left_lr >=1 && right_lr <=size(img.deblocked,2)
                        img_crop = img.deblocked(top_lr:bottom_lr, left_lr:right_lr,:);
                        %save the cropped region in raw for comparing images generated
                        %by 
                        imwrite(img.raw(top_lr:bottom_lr, left_lr:right_lr,:), fullfile(folder_save, sprintf('%s_%d_raw.png',fn_short, idx_face)));
                    else
                        %skip this face
                        continue
                    end
                case 3
                    img_crop = img.deblocked(top_lr:bottom_lr, left_lr:right_lr,:);
                case 4
                    img_crop = img.deblocked;
            end
            %shift the landmark_multipei
            landmark.cropped_region_lr.multipie = F36_ShiftLandmark( landmark.test_image_lr.multipie, left_lr-1, top_lr-1);
            landmark.cropped_region_hr.multipie = F58_ConvertCooridnateBetweenHRLR(landmark.cropped_region_lr.multipie, scalingfactor, 'LR');

            if option_generate_a_figure_with_localized_landmarks
                bshowtext = true;
                bvisible = false;
                circlesize = 10;
                hfig = U9a_DrawMultiPieLandmarkVisualCheck(img_crop,landmark.cropped_region_lr.multipie,bshowtext, bvisible, circlesize);
                fn_save_landmark_image = sprintf('%s_%d_%s_%s_landmark.jpg',fn_short,idx_face,string_localization_algorithm, string_test_number);
                saveas(hfig, fullfile(folder_save,fn_save_landmark_image));
                close(hfig);
                clear hfig
            end

            tStart = tic;
            img_ycbcr = rgb2ycbcr(img_crop);
            img_y = img_ycbcr(:,:,1);

            U3_ReportTime(toc(tStart), fn_log , 'after landmark localization before F37j_GetTexturePatchMatch');
            img_y_ext = wextend('2d','symw',img_y,extend_width_lr);
            ANR_result = scaleup_ANR(conf, {img_y_ext});  %maybe I need to retrain this conf because the Y is of YIQ rather than YCbCr
            img.HR.initial = ANR_result{1}(1+extend_with_hr:end-extend_with_hr,1+extend_with_hr:end-extend_with_hr);
            gradientwholeimage = F14c_Img2Grad_fast_suppressboundary(img.HR.initial);

            [h_lr, w_lr] = size(img_y);
            h_hr = h_lr * scalingfactor;
            w_hr = w_lr * scalingfactor;
            gradient_zdim = 8;
            gradient_component = zeros(h_hr,w_hr,gradient_zdim);

            %Component setting
            componentlandmarkset = cell(4,1);
            setname = cell(4,1);
            componentlandmarkset{1} = 49:66;        %mouth
            componentlandmarkset{2} = 28:36;        %nose
            componentlandmarkset{3} = 18:27;        %eyebrows
            componentlandmarkset{4} = 37:48;        %eyes
            setname{1} = 'mouth';
            setname{2} = 'nose';
            setname{3} = 'eyebrows';
            setname{4} = 'eyes';
            two_point_index{1} = [1; 7]; %the 49th and 55th, the left-most and right-most points
            two_point_index{2} = [1; 7]; %the 28th and 34th, the top-most and down-most points
            two_point_index{3} = [1; 10]; %the 18th and 27th, the left-most and right-most points
            two_point_index{4} = [1; 10]; %the 37th and 46th, the left-most and right-most points

            multipie_camera_name = F60_ClosestCamera(output.pose.angle(2));
            if strcmp(multipie_camera_name, '190') || strcmp(multipie_camera_name, '041') || strcmp(multipie_camera_name, '050') || ...
                strcmp(multipie_camera_name, '051') || ...
                strcmp(multipie_camera_name, '130') || strcmp(multipie_camera_name, '140') || strcmp(multipie_camera_name, '080')
            else
                error('not supported yet.');
            end
            %predict the illumination
            loaddata = load(fullfile('Result','PP23b_TrainIlluminationModels',sprintf('%s_illumination_estimation_model.mat',multipie_camera_name)));
            idx_illumination = F62b_EstimateIllumination_Disregard00(img_crop, landmark.cropped_region_lr.multipie, loaddata.model);
            clear loaddata
            illumination_appendix = sprintf('_%02d',idx_illumination-1);
            U3a_log(fn_log, sprintf('idx_face %d, camera_position %s, illumination %02d', idx_face, multipie_camera_name,idx_illumination-1));

            %load landmark and glass list
            filename_list_landmarks = sprintf('MultiPIE_landmarks_%s.txt', multipie_camera_name);
            folder_landmarks = fullfile(folder_multipie, 'labeled data From Ralph Gross','MPie_Labels','labels',multipie_camera_name);
            list_landmarks = U5_ReadFileNameList(fullfile(folder_filelist,filename_list_landmarks));
            %load landmarks
            for i=1:length(list_landmarks)
                loaddata = load(fullfile(folder_landmarks, list_landmarks{i}));
                switch length(loaddata.pts)
                    case 68
                        example(i).landmark = F1c_ConvertLandmarks_68FormatTo66Format(loaddata.pts);
                    case 66
                        example(i).landmark = loaddata.pts;
                    otherwise
                        error('not support');
                end
                example(i).filename = list_landmarks{i}(1:16);
                [subject_id, session_number, expression_number] = F64_ParseMultiPIE_Filename(example(i).filename);
                example(i).bglass = glass_table(subject_id).session(session_number).b_glass(expression_number);
            end
            
            %use the extra landmarks
            list_landmarks_extra = U5_ReadFileNameList(fullfile(folder_filelist,['MultiPIE_landmarks_' multipie_camera_name '_Extra.txt']));
            for j=1:length(list_landmarks_extra)
                example(i+j).filename = list_landmarks_extra{j}(1:13);
                [subject_id, session_number, expression_number] = F64_ParseMultiPIE_Filename(example(i+j).filename);
                example(i+j).bglass = glass_table(subject_id).session(session_number).b_glass(expression_number);
                loaddata = load(fullfile('landmarks',['Extra_' multipie_camera_name], list_landmarks_extra{j}));
                example(i+j).landmark = F1d_ConvertLandmark_Intraface_to_MultiPie_66points(loaddata.pts);
            end

            landmarksetnumber = length(componentlandmarkset);
            for k=1:landmarksetnumber
                set = componentlandmarkset{k};
                switch setname{k}
                    case 'mouth'
                        bFeather = true;
                        [mask_lr, mask_hr] = F32b_ComputeMask_CloseRegion(h_hr, w_hr, landmark.cropped_region_hr.multipie(set,:), scalingfactor, Gau_sigma, bFeather);
                        bglassavoid = false;
                    case 'eyebrows'
                        [mask_lr, mask_hr] = F33b_ComputeMask_Eyebrows(h_hr, w_hr, landmark.cropped_region_hr.multipie, scalingfactor, Gau_sigma, bFeather);
                        bglassavoid = true;
                    case 'eyes'
                        [mask_lr, mask_hr] = F34b_ComputeMask_Eyes(h_hr, w_hr, landmark.cropped_region_hr.multipie, scalingfactor, Gau_sigma, bFeather);
                        bglassavoid = true;
                    case 'nose'
                        [mask_lr, mask_hr] = F35b_ComputeMask_Nose(h_hr, w_hr, landmark.cropped_region_hr.multipie, scalingfactor, Gau_sigma, bFeather);
                        bglassavoid = true;
                end

                basepoints = landmark.cropped_region_hr.multipie(set,:);
                %inputpoints = exemplar_landmarks(set,:,:);
                index_two_points_for_alignment = two_point_index{k};        
                fprintf('running %s\n',setname{k});
                K = 100;
                [list_K_most_similar, transformmatrix] = F61a_FindMostSimilarLandmarks(basepoints, example, set, index_two_points_for_alignment, K, bglassavoid);
                array_normvalue = zeros(K,1);
                [r_set, c_set] = find(mask_lr);
                top = min(r_set);
                bottom = max(r_set);
                left = min(c_set);
                right = max(c_set);
                area_test = im2double(img_y(top:bottom,left:right));
                area_mask = mask_lr(top:bottom,left:right);
                area_test_aftermask = area_test .* area_mask;
                [test_component.brightness.mean, test_component.brightness.weighted_std] = ...
                    F63_ComputeMaskedMeanStd(area_test,area_mask);
                %extract feature from the eyerange, the features are the gradient of LR eye region
                feature_test = F24_ExtractFeatureFromArea(area_test_aftermask);     %the unit is double
                outputsize = [h_hr w_hr];
                for idx = 1:K
                    fn_short_image = [example(list_K_most_similar(idx)).filename(1:10) multipie_camera_name illumination_appendix];
                    subfolder_multipie = F51_MultiPIE_file_name_to_folder_string(fn_short_image);
                    img_example = imread(fullfile(folder_multipie,'data',subfolder_multipie,[fn_short_image '.png']));
                    ycc = rgb2ycbcr(img_example);
                    exampleimages_hr_y = ycc(:,:,1);
                    alignedexampleimage_hr = F49a_GenerateAlignedImage_AnySize(exampleimages_hr_y,transformmatrix(:,:,idx),outputsize);
                    alignedexampleimage_lr = F19c_GenerateLRImage_GaussianKernel(alignedexampleimage_hr,scalingfactor,Gau_sigma);
                    examplearea_lr = alignedexampleimage_lr(top:bottom,left:right);
                    examplearea_lr_aftermask = examplearea_lr .* area_mask;
                    %Adjust the brightness and std of the exemplar component to
                    %match the test component.
                    [candidate.LR.brightness.mean, candidate.LR.brightness.weighted_std] =...
                        F63_ComputeMaskedMeanStd(examplearea_lr, area_mask);
                    std_adjust_ratio = test_component.brightness.weighted_std / candidate.LR.brightness.weighted_std;
                    candidate.LR.adjusted = (examplearea_lr - candidate.LR.brightness.mean) * std_adjust_ratio + test_component.brightness.mean;
                    feature_example_lr = F24_ExtractFeatureFromArea(candidate.LR.adjusted .* area_mask);     %the unit is double
                    array_normvalue(idx) = norm(feature_test - feature_example_lr);
                end
                [~, index_most_similar_exemplar_in_K] = min(array_normvalue); 
                fn_short_image = [example(list_K_most_similar(index_most_similar_exemplar_in_K)).filename(1:10) multipie_camera_name illumination_appendix];

                subfolder_multipie = F51_MultiPIE_file_name_to_folder_string(fn_short_image);
                img_example = imread(fullfile(folder_multipie,'data',subfolder_multipie,[fn_short_image '.png']));
                ycc = rgb2ycbcr(img_example);
                exampleimages_hr_y = ycc(:,:,1);
                retrievedhrimage = F49a_GenerateAlignedImage_AnySize(exampleimages_hr_y,transformmatrix(:,:,index_most_similar_exemplar_in_K),outputsize); 
                %Adjust the brightness of the retrieved HR image
                alignedexampleimage_lr = F19c_GenerateLRImage_GaussianKernel(retrievedhrimage,scalingfactor,Gau_sigma);
                examplearea_lr = alignedexampleimage_lr(top:bottom,left:right);
                [examplar.LR.brightness.mean, examplar.LR.brightness.weighted_std] =...
                    F63_ComputeMaskedMeanStd(examplearea_lr, area_mask);
                std_adjust_ratio = test_component.brightness.weighted_std / examplar.LR.brightness.weighted_std;
                examplar.HR.adjusted = (retrievedhrimage - examplar.LR.brightness.mean) * std_adjust_ratio + test_component.brightness.mean;
                U3a_log(fn_log, sprintf('std_adjust_ratio %0.2f, examplar.LR.brightness.mean %0.3f, test_component.brightness.mean %0.3f', std_adjust_ratio, examplar.LR.brightness.mean, test_component.brightness.mean));


                [r_set, c_set] = find(mask_hr);
                top = min(r_set);
                bottom = max(r_set);
                left = min(c_set);
                right = max(c_set);

                originalgradients = gradientwholeimage(top:bottom,left:right,:);
                retrievedgradients_wholeimage = F14_Img2Grad(im2double(examplar.HR.adjusted));
                retrievedgradients = retrievedgradients_wholeimage(top:bottom,left:right,:);
                mask_region = mask_hr(top:bottom,left:right);

                gradientwholeimage(top:bottom,left:right,:) = ...
                    retrievedgradients.* repmat(mask_region,[1 1 8]) + ...
                    originalgradients .* repmat(1-mask_region,[1 1 8]);
                gradient_component(top:bottom,left:right,:) = retrievedgradients .* repmat(mask_region,[1 1 8]);
            end
            U3_ReportTime(toc(tStart), fn_log , 'after generating component gradients');


            %solve optimization problem
            Grad_exp = gradientwholeimage;

            %this step is very critical, if the optimization is not strong enough, the textural details do not show
            %so, F4d is too weak to be used here
            bReport = true;
            loopnumber = 30;
            totalupdatenumber = 10;
            linesearchstepnumber = 20;
            beta0 = 1;
            beta1 = 6.4;
            %in the paper, beta0 (intensity) equals 1,
            %beta1 (gradients) equals beta. 
            tolf = 0.001;
            img_out = F4e_GenerateIntensityFromGradient(img_y,img.HR.initial, ...
                Grad_exp,Gau_sigma,bReport, loopnumber,totalupdatenumber,...
                linesearchstepnumber,beta0,beta1,tolf);
            U3_ReportTime(toc(tStart), fn_log , 'F4e_GenerateIntensityFromGradient');

            img_out_ycbcr = img_out;
            img_out_ycbcr(:,:,2:3) = imresize(img_ycbcr(:,:,2:3),scalingfactor);
            img_out_rgb = ycbcr2rgb(img_out_ycbcr);

            U3_ReportTime(toc(tStart), fn_log , 'generate img_out_rgb');
            imwrite(img_out_rgb, fullfile(folder_save,fn_save));
        end
    end
end