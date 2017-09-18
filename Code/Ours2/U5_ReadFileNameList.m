%Chih-Yuan Yang
%04/06/15
function filenamelist = U5_ReadFileNameList( fn_list )
    fid = fopen(fn_list,'r');
    A = fileread(fn_list);
    number_rn = length(strfind(A,sprintf('\r\n')));
    number_n = length(strfind(A,sprintf('\n')));
    if number_rn == number_n
        C = textscan(fid,'%d %s\r\n');
    else
        C = textscan(fid,'%d %s\n');
    end        
    fclose(fid);
    filenamelist = C{2};
end

