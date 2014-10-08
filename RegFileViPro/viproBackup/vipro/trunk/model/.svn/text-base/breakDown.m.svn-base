% load data
files = dir('*_m.txt');
for i=1:length(files)
    load(files(i).name);
end

rows = [];
cols = [];

% Get vectors for rows and cols
for i=1:length(files)/2
    rc = regexp(files(i).name,'\d+','match');
    rows = [rows str2double(rc(1))];
    cols = [cols str2double(rc(2))];
end

D_R1024_C16_txt_m = [sum(D_R1024_C16_txt_m); D_R1024_C16_txt_m(1:5) ; D_R1024_C16_txt_m(7)];
D_R512_C32_txt_m = [sum(D_R512_C32_txt_m); D_R512_C32_txt_m(1:5) ; D_R512_C32_txt_m(7)];
D_R256_C64_txt_m = [sum(D_R256_C64_txt_m); D_R256_C64_txt_m(1:5) ; D_R256_C64_txt_m(7)];
D_R128_C128_txt_m = [sum(D_R128_C128_txt_m); D_R128_C128_txt_m(1:5) ; D_R128_C128_txt_m(7)];
D_R64_C256_txt_m = [sum(D_R64_C256_txt_m); D_R64_C256_txt_m(1:5) ; D_R64_C256_txt_m(7)];
D_R32_C512_txt_m = [sum(D_R32_C512_txt_m); D_R32_C512_txt_m(1:5) ; D_R32_C512_txt_m(7)];
D_R16_C1024_txt_m = [sum(D_R16_C1024_txt_m); D_R16_C1024_txt_m(1:5) ; D_R16_C1024_txt_m(7)];
D_R8_C2048_txt_m = [sum(D_R8_C2048_txt_m); D_R8_C2048_txt_m(1:5) ; D_R8_C2048_txt_m(7)];

E_R1024_C16_txt_m = [sum(E_R1024_C16_txt_m);E_R1024_C16_txt_m];
E_R512_C32_txt_m = [sum(E_R512_C32_txt_m); E_R512_C32_txt_m];
E_R256_C64_txt_m = [sum(E_R256_C64_txt_m); E_R256_C64_txt_m];
E_R128_C128_txt_m = [sum(E_R128_C128_txt_m); E_R128_C128_txt_m];
E_R64_C256_txt_m = [sum(E_R64_C256_txt_m); E_R64_C256_txt_m];
E_R32_C512_txt_m = [sum(E_R32_C512_txt_m);E_R32_C512_txt_m ];
E_R16_C1024_txt_m = [sum(E_R16_C1024_txt_m);E_R16_C1024_txt_m];
E_R8_C2048_txt_m = [sum(E_R8_C2048_txt_m);E_R8_C2048_txt_m];

% Plot bargraph
figure(1);
bar([D_R1024_C16_txt_m D_R512_C32_txt_m D_R256_C64_txt_m D_R128_C128_txt_m D_R64_C256_txt_m...
   D_R32_C512_txt_m D_R16_C1024_txt_m D_R8_C2048_txt_m]');
hleg = legend('Total','Decoder','write ckt','WLDriver','SA', 'flip','BL droop','location','NorthEast');
set(hleg,'fontsize',6);
legend('boxoff');

figure(2);
bar([E_R1024_C16_txt_m E_R512_C32_txt_m E_R256_C64_txt_m E_R128_C128_txt_m E_R64_C256_txt_m...
    E_R32_C512_txt_m E_R16_C1024_txt_m E_R8_C2048_txt_m]');
hleg = legend('Total','Decoder','ColDecMux', 'flip', 'WrtCkt','RdCkt', 'WLDriver','SA','Lkg', 'location','NorthWest');
set(hleg,'fontsize',6);
legend('boxoff');

%exit;