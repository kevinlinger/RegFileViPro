%======================================================================
%== FUNCTION: the inverse CDF of Vmin
%== Parameters:
%==   mu0: the initial mean of SNM0 @v0
%==   sig0:  the initial sigma of SNM0 @v0
%==   v0:  the initial vdd
%==   a, b:  p=polyfit(vdd,mu,2);a=p(1);b=p(2) 
%==   c:     q=polyfit(vdd,sig,1);c=q(1) 
%==   s:     the SNM threshold value for a failure
%==   F:     the probability vector
%==
%== Jiajing Wang -- 04/09/09
%======================================================================
function [Vmin] = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F)

t=erfcinv(2-2*sqrt(F));
cc = sqrt(2).*sig0.*t-mu0+s + a*v0.^2 + b*v0 - sqrt(2)*c*v0.*t;
bb = b-sqrt(2)*c.*t;
aa = a;
%r=bb.^2+4.*aa.*cc;
%disp(sqrt(r));
%find(r<0)
%F(find(r<0))
Vmin = real((sqrt(bb.^2+4.*aa.*cc)-bb)./(2*aa));



