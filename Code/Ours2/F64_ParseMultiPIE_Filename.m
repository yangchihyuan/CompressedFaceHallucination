%Chih-Yuan Yang
%6/25/2016 I need a function to parse MultiPIE filename
function [subject_id, session_number, expression_number, camera_id, illumination]=...
    F64_ParseMultiPIE_Filename(filename)
    subject_id = str2double(filename(1:3));
    session_number = str2double(filename(5:6));
    expression_number = str2double(filename(8:9));
    if length(filename) >= 13
        camera_id = filename(11:13);
    else
        camera_id = [];
    end
    if length(filename) >= 16
        illumination = filename(15:16);
    else
        illumination = [];
    end
end