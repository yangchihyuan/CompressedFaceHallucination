%Chih-Yuan Yang
%F51 7/24/2015 I create this function by copying a piece previously used code.
%This function is identical to F46 and can replace F46.

function string_folder = F51_MultiPIE_file_name_to_folder_string(string_file_name)
    A = sscanf(string_file_name,'%03d_%02d_%02d_%02d%01d_%02d');
    subjectid = A(1);
    sessionnumber = A(2);
    expressionnumber = A(3);
    cameraid_major = A(4);
    cameraid_minor = A(5);
    illuminationid = A(6);
    string_folder = fullfile(sprintf('session%02d',sessionnumber),'multiview',...
        sprintf('%03d',subjectid),sprintf('%02d',expressionnumber),sprintf('%02d_%01d',cameraid_major,cameraid_minor));
end