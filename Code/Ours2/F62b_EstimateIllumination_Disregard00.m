%Chih-Yuan Yang
%06/11/2016 F62 I need a function to estimate the illumination on faces.
%06/13/2016 F62a I change the argument into a model
%06/15/2016 F62b I try to disregard illumination 00 because those images
%are too dark and noisy.

%img_crop: input face image
%landmark_lr_multipie: landmarks in MultiPIE 66-point format
%model: cell{20,1}: the pre-trained illuminated faces w.r.t. an illumination setting
%idx_illumination: a scalar from 2 to 19, indicating of the X-th illumination setting 
%in the Multi-PIE setting
function idx_illumination = F62b_EstimateIllumination_Disregard00(img_crop, landmark_lr_multipie, model)
    %align img_crop to two given points
    [~,~, center_righteye, center_lefteye] = F57_EyeCenterFromLandmarks(landmark_lr_multipie);
    bTwoRows = true;
    transformmatrix = F44a_ComputeTransformMatrix(cat(1,center_righteye, center_lefteye), model.twopoints_align_to, bTwoRows);
    outputsize = [80 60];
    img.aligned = F49a_GenerateAlignedImage_AnySize(rgb2gray(img_crop),transformmatrix,outputsize);
    img.cropped = im2double(reshape(img.aligned(model.mask_cropped_region), model.mask_size));
    img_mean = mean(img.cropped(:));
    img_std = std(img.cropped(:),1);
    img.cropped_normalized = (img.cropped - img_mean)/img_std;
    
    array_norm = zeros(18,1);
    for k = 1:18
        diff = img.cropped_normalized - model.img_cropped_normalized{k+1};  % model.img_cropped_normalized{1} means illumination 00, skip it
        array_norm(k) = sqrt(sum(sum(diff.^2)));
    end
    [~,idx_min_norm] = min(array_norm);
    idx_illumination = idx_min_norm + 1;
end
