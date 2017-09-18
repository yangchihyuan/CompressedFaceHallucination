%Chih-Yuan Yang
%05/31/2016 I need a function to conver the angles of a head estimated by
%IntraFace to the closest camera position used in Multi-PIE so that I can
%exploit the exemplar images in the Multi-PIE dataset
function camera_string = F60_ClosestCamera(raw_angle)
    if raw_angle < 97.5 && raw_angle > 82.5
        camera_string = '240';
    elseif raw_angle <= 82.5 && raw_angle > 67.5
        camera_string = '120';
    elseif raw_angle <= 67.5 && raw_angle > 52.5
        camera_string = '090';
    elseif raw_angle <= 52.5 && raw_angle > 37.5
        camera_string = '080';
    elseif raw_angle <= 37.5 && raw_angle > 22.5
        camera_string = '130';
    elseif raw_angle <= 22.5 && raw_angle > 7.5
        camera_string = '140';
    elseif raw_angle <= 7.5 && raw_angle >= -7.5
        camera_string = '051';
    elseif raw_angle < -7.5 && raw_angle >= -22.5
        camera_string = '050';
    elseif raw_angle < -22.5 && raw_angle >= -37.5
        camera_string = '041';
    elseif raw_angle < -37.5 && raw_angle >= -52.5
        camera_string = '190';
    elseif raw_angle < -52.5 && raw_angle >= -67.5
        camera_string = '200';
    elseif raw_angle < -67.5 && raw_angle >= -82.5
        camera_string = '010';
    elseif raw_angle < -82.5 && raw_angle >= -97.5
        camera_string = '110';
    end
% 90¢X right (110 camera): 72 (not managed)
% 75¢X right (010 camera): 71 (not managed)
% 60¢X right (200 camera): 71 (not managed)
% 45¢X right (190 camera): 284 (not managed)
% 30¢X right (041 camera): 285 (not managed)
% 15¢X right (050 camera): 644 (not managed)
% 0¢X (051 camera): 2509 (excluded 17 instances in #07 illumination)
% 15¢X left (140 camera): 647 (not managed)
% 30¢X left (130 camera): 386 (not managed)
% 45¢X left (080 camera): 417 (not managed)
% 60¢X left (090 camera): 263 (not managed)
% 75¢X left (120 camera): 261 (not managed)
% 90¢X left (240 camera): 72 (not managed)
end

