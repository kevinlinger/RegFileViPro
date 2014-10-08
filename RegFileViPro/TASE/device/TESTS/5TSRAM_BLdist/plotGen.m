d0 = load('5TSRAM_BLdist/OUT/DAT0/monteCarlo/mcdata');
d1 = load('5TSRAM_BLdist/OUT/DAT1/monteCarlo/mcdata');

d5 = max([d0(:,1) d1(:,1)],[],2);
d6 = max([d0(:,2) d1(:,2)],[],2);

[u5,s5] = normfit(d5);
[u6,s6] = normfit(d6);

m5 = max(d5);
m6 = max(d6);

fid = fopen('data.txt','w');
fprintf(fid, '%e\t%e\t%e\t%e\t%e\t%e\n', u5,s5,m5,u6,s6,m6);
fclose(fid);

