%Chih-Yuan Yang
%U3: report time. This function is desinged to report time for our PAMI submission
function U3_ReportTime(time, filename, description)
    fid = fopen(filename,'a+');
    fprintf(fid,'%s %f \n', description, time);
    fclose(fid);
end