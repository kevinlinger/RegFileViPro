% load delay data
load('RVP_Gate_Capacitance/cap.txt');

% Find cap with min delay difference
diff = abs(cap(:,2)-cap(:,3));

[mind,i] = min(diff);

% Write per micron gate cap value to file - assumes p and nmos have same gate cap
fid = fopen('RVP_Gate_Capacitance/data.txt','w');

if (mind < <tol>)
	fprintf(fid, '%e\n',cap(i,1)/(3*32*<minw>*1e6));
end

fclose(fid);
