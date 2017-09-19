%Chih-Yuan Yang
%06/04/2016 F1c: There are two formats in the landmark files. I need a
%function to convert files from the 68-point format to the 66-point format.
function landmark_out = F1c_ConvertLandmarks_68FormatTo66Format(landmark_in)
    landmark_out = zeros(66,2);
    landmark_out(1:60,:) =landmark_in(1:60,:);
    landmark_out(61:63,:) = landmark_in(62:64,:);
    landmark_out(64:66,:) = landmark_in(66:68,:);
end

