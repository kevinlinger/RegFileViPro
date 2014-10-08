%##############################################################
%#      MATLAB code to plot SRAM BL voltage droop             # 
%#          vs. access transistor VT variation                #
%##############################################################

%load data%
rownum = [16 32 64 128 256 512 1024];


R = size(rownum,2);


K = 8;

VBL0 = zeros(R,K);
VBL1 = zeros(R,K);
dVBL = zeros(R,K);

for i=1:1:R
  %% For differential Read %%
  f0name=sprintf('subvtSRAM_VBL_vs_rownum/DAT/R%d_D0.dat',rownum(i));
  f0=load(f0name);
  VBL0(i,1:3)=f0(1,1:3);
  VBL1(i,1:3)=f0(1,4:6);
  
  
  %% For single-ended Read %%
  VBL0(i,4:8)=f0(1,7:end-2);
  f1name=sprintf('subvtSRAM_VBL_vs_rownum/DAT/R%d_D1.dat',rownum(i));
  f1=load(f1name);
  VBL1(i,4:8)=f1(1,7:end-2);
end

% plot VBL when Q=0 %
plot(rownum,VBL0,'-o','lineWidth',2);
grid on;
xlabel('#. of rows','fontsize',12);
ylabel('VBL0 (V)','fontsize',12);
title('VBL0 vs. #. of rows','fontsize',16);
legend('6T','10T-chang','10T-st','8T','8T-footboost','10T-ben','10T-kim','7T',-1);
%save and close%
%print(gcf, '-depsc', 'subvtSRAM_VBL_vs_rownum/IMG/subvtSRAM_VBL0_vs_rownum.eps');
close(gcf);


% plot VBL when Q=1 %
plot(rownum,VBL1,'-o','lineWidth',2);
grid on;
xlabel('#. of rows','fontsize',12);
ylabel('VBL1 (V)','fontsize',12);
title('VBL1 vs. #. of rows','fontsize',16);
legend('6T','10T-chang','10T-st','8T','8T-footboost','10T-ben','10T-kim','7T',-1);
%save and close%
%print(gcf, '-depsc', 'subvtSRAM_VBL_vs_rownum/IMG/subvtSRAM_VBL1_vs_rownum.eps');
close(gcf);


% plot dVBL %
dVBL = VBL1 - VBL0;
plot(rownum,dVBL,'-o','lineWidth',2);
grid on;
xlabel('#. of rows','fontsize',12);
ylabel('(VBL1-VBL0) (V)','fontsize',12);
title('(VBL1-VBL0) vs. #. of rows','fontsize',16);
legend('6T','10T-chang','10T-st','8T','8T-footboost','10T-ben','10T-kim','7T',-1);
%save and close%
%print(gcf, '-depsc', 'subvtSRAM_VBL_vs_rownum/IMG/subvtSRAM_VBL_vs_rownum.eps');
close(gcf);


% plot mVBL %
f = load('subvtSRAM_VBL_vs_rownum/DAT/dVBLmax.dat');
plot(f(:,1),f(:,2:end),'-o','lineWidth',2);
grid on;
xlabel('#. of rows','fontsize',12);
ylabel('max(VBL1-VBL0) (V)','fontsize',12);
title('max(VBL1-VBL0) vs. #. of rows','fontsize',16);
legend('6T','10T-chang','10T-st','8T','8T-footboost','10T-ben','10T-kim','7T',-1);
%save and close%
print(gcf, '-depsc', 'subvtSRAM_VBL_vs_rownum/IMG/subvtSRAM_mBL_vs_rownum.eps');
close(gcf);

