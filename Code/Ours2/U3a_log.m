%Chih-Yuan Yang
%7/16/2016
%U3: report time. This function is desinged to report time for our PAMI submission
%U3a: make a log because I want to know the execution machine
function U3a_log(filename, description, b_showtime)
    if nargin < 3
        b_showtime = true;
    end
    fid = fopen(filename,'a+');
    if b_showtime
        fprintf(fid,'%s %s\n', datestr(now), description);
    else
        fprintf(fid,'%s\n', description);
    end
    fclose(fid);
end