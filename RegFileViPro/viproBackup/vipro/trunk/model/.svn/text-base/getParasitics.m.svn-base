%%%%%%%%%%%%%%
% This function determines global, local, and intermediate metal R and C for a given technology using the InterconnectCap function that is based on the PTM interconnect model, and writes the results to parasitics.txt in the files/ directory. Custom values for interconnect metal, wire parameters etc. can be specified in user.m
%%%%%%%%%%%%%%

function getParasitics(toolPath,techNum)

chdir(strcat(toolPath,'/configuration'));
user;

chdir(strcat(toolPath,'/model'));
[R_global C_global] = InterconnectCap(techNum,'g',globalMtl,globalParams);
[R_inter C_inter] = InterconnectCap(techNum,'i',interMtl,interParams);
[R_local C_local] = InterconnectCap(techNum,'l',localMtl,localParams);

fid = fopen(strcat(toolPath,'/files/parasitics.txt'),'w');
fprintf(fid, '%e\t%e\n', R_global,C_global);
fprintf(fid, '%e\t%e\n', R_inter,C_inter);
fprintf(fid, '%e\t%e\n', R_local,C_local);
fclose(fid);

exit;
