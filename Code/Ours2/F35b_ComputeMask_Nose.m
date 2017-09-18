%Chih-Yuan Yang
%07/20/14
%F35a: I add new inputs to support the scaling factor of 3. I also replace F19a to F19c.
%5/24/2015 F34b: I need to control the output mask size to apply our
%algorithm on test images of any size.
function [mask_lr, mask_hr] = F35b_ComputeMask_Nose(mask_height, ...
    mask_width, landmarks_hr,scalingfactor,Gau_sigma, bFeather)
    mask_hr = zeros(mask_height,mask_width);

    setrange = 28:36;
    checkpair = [28 32;
                 32 33;
                 33 34;
                 34 35;
                 35 36;
                 36 28;];
    for k=1:size(checkpair,1);
        i = checkpair(k,1);
        j = checkpair(k,2);
        %mark the pixel between i and j
        coor1 = landmarks_hr(i,:);
        coor2 = landmarks_hr(j,:);
        x1 = coor1(1);
        c1 = round(x1);
        y1 = coor1(2);
        r1 = round(y1);
        x2 = coor2(1);
        c2 = round(x2);
        y2 = coor2(2);
        r2 = round(y2);
        a = y2-y1;
        b = x1-x2;
        c = (x2-x1)*y1 - (y2-y1)*x1;
        sqra2b2 = sqrt(a^2+b^2);
        rmin = min(r1,r2);
        rmax = max(r1,r2);
        cmin = min(c1,c2);
        cmax = max(c1,c2);
        for rl=rmin:rmax
            for cl=cmin:cmax
                y_test = rl;
                x_test = cl;
                distance = abs(a*x_test+b*y_test +c)/sqra2b2;
                if distance <= sqrt(2)/2
                    mask_hr(rl,cl) = 1;
                end
            end
        end
    end
    %fill the interior
    left_coor = min(landmarks_hr(setrange,1));
    right_coor = max(landmarks_hr(setrange,1));

    left_idx = round(left_coor);
    right_idx = round(right_coor);
    for cl = left_idx:right_idx
        rmin = find(mask_hr(:,cl),1,'first');
        rmax = find(mask_hr(:,cl),1,'last');
        if rmin ~= rmax
            mask_hr(rmin+1:rmax-1,cl) = 1;
        end
    end

    %dilate the get the surrounding region
    radius = 6;
    approximateN = 0;
    se = strel('disk',radius,approximateN);
    mask_hr = imdilate(mask_hr,se);

    %blur the boundary
    if bFeather
        mask_hr = imfilter(mask_hr,fspecial('gaussian',11,1.6));
    end

    mask_lr = F19c_GenerateLRImage_GaussianKernel(mask_hr,scalingfactor,Gau_sigma);
end
