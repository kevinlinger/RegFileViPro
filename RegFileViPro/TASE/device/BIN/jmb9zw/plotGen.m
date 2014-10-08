function plotGen ()
try

%dummy plotGen file.

exit;
catch
fid = fopen('matlab.err','wt');
fprintf(fid,'Syntax Error: m-file');
fclose(fid);
exit;
end
