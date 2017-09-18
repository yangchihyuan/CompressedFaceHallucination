%Chih-Yuan Yang
%2016/6/30 U30 I create a glass table to replace glass list. Now I need a
%utility function to load it.
function table = U30_LoadGlassTable(filename)
    table = struct('session',struct('b_glass',[]));
    fid = fopen(filename, 'r');
    while ~feof(fid)
        linedata = fgetl(fid);
        readdata = sscanf(linedata, '%d %d %d %d %d %d %d %d %d %d %d %d');
        if length(readdata) > 2
            subject_id = readdata(1);
            table(subject_id).session(1).b_glass = readdata(2:3);
            table(subject_id).session(2).b_glass = readdata(4:6);
            table(subject_id).session(3).b_glass = readdata(7:9);
            table(subject_id).session(4).b_glass = readdata(10:12);
        end
    end
end