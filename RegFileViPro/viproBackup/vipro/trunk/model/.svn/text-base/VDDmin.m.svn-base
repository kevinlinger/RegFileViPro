% VDDmin for various array sizes

mu0 = 0.05664;
sig0 = 0.01583;
v0 = 0.4;
vdd = [0.7 0.6 0.5 0.4];
sig = [0.01614 0.01596 0.01584 0.01583];
mu = [0.17416 0.13084 0.09139 0.05664];
p=polyfit(vdd,mu,2);a=p(1);b=p(2);
q=polyfit(vdd,sig,1);c=q(1);
s = 0;
%F = 1 - 1e-5*[4.8 2.4 1.2 0.6 0.3 99999.7887545298];
F = normcdf(6,0,1);

Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F);



% mu0: the initial mean of SNM0 @v0
% sig0:  the initial sigma of SNM0 @v0
% v0:  the initial vdd
% a, b:  p=polyfit(vdd,mu,2);a=p(1);b=p(2)
% c:     q=polyfit(vdd,sig,1);c=q(1)
% s:     the SNM threshold value for a failure
% F:     the probability vector