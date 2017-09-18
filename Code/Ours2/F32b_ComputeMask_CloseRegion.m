%Chih-Yuan Yang
%F32a 07/20/14 I add new inputs to support the scaling factor of 3. I also replace F19a to F19c.
%F32b 07/26/15 I extend this function to compute a close region. Thus it can be used for mouth and
%the whole face.
%(A supplementary note added on 5/24/2016: The P32b function is only used
%by PP20, and the motivation is reported in the research log.
%Be aware, F32b does not work for noses because the order of the landmarks.
%6/27/2016 Be aware, there is a bug to use F32b on a mouth. The point 49
%should connect to point 60 to enclose the mouth. But F32b omits this.
function [mask_lr, mask_hr] = F32b_ComputeMask_CloseRegion(mask_height, ...
    mask_width, landmarks_hr, scalingfactor, Gau_sigma, bFeather)
    %arguments:
    %landmarks_hr: [n x 2]
    %bFeather: this option decides whether the mask_hr will be feathered
    mask_hr = zeros(mask_height,mask_width);
    num_landmarks = size(landmarks_hr,1);
    for k=1:num_landmarks
        coor1 = landmarks_hr(k,:);
        if k~=num_landmarks
            coor2 = landmarks_hr(k+1,:);
        else
            coor2 = landmarks_hr(1,:);
        end
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
    left_coor = min(landmarks_hr(:,1));
    right_coor = max(landmarks_hr(:,1));

    left_idx = round(left_coor);
    right_idx = round(right_coor);
    for cl = left_idx:right_idx
        rmin = find(mask_hr(:,cl),1,'first');
        rmax = find(mask_hr(:,cl),1,'last');
        if rmin ~= rmax
            mask_hr(rmin+1:rmax-1,cl) = 1;
        end
    end
    
    %blur the boundary
    if bFeather
        mask_hr = imfilter(mask_hr,fspecial('gaussian',11,1.6));
    end
    mask_lr = F19c_GenerateLRImage_GaussianKernel(mask_hr,scalingfactor,Gau_sigma);
end
