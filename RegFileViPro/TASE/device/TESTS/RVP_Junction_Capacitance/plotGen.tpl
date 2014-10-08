% load delay data
load('RVP_Junction_Capacitance/cap.txt');

% Find cap with min delay difference
diff = abs(cap(:,2)-cap(:,3));

[mind,i] = min(diff);

% Write per micron junction cap value to file - this also will include the overlap cap
fid = fopen('RVP_Junction_Capacitance/data.txt','w');
fprintf(fid, '%e\n',cap(i,1)/(<wcap>*1e6));
fclose(fid);
