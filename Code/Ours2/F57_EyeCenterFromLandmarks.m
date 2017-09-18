%Chih-Yuan Yang
%05/27/2016 I create F57 to crop faces from input images.

%landmark_multipei: [m x 2]
function [ eye_center, eye_distance, center_righteye, center_lefteye] = F57_EyeCenterFromLandmarks( landmark_multipei )
    set_righteye = 37:42;       %right eye of the subject
    set_lefteye = 43:48;       %left eye of the subject
    points_righteye = landmark_multipei(set_righteye,:);
    points_lefteye = landmark_multipei(set_lefteye,:);
    center_righteye = mean(points_righteye);
    center_lefteye = mean(points_lefteye);
    eye_center = mean( cat(1,center_righteye, center_lefteye));
    diff = center_righteye - center_lefteye;
    eye_distance = sqrt(sum(diff.^2));
end

