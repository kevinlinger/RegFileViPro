function plotGen ()
try

%dummy file

exit;
catch
fid = fopen('matlab.err','wt');
fprintf(fid,'Syntax Error: m-file');
fclose(fid);
exit;
end
