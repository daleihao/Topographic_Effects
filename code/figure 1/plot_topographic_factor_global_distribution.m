clc
clear all;



topDir = 'C:\Users\haod776\OneDrive - PNNL\Documents\work\proposal_&_code\UCLA_3D_Topo_Data\UCLA_3D_Topo_Data\';
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40
topFilenames = {'topo_3d_0.125x0.125.nc','topo_3d_0.25x0.25.nc','topo_3d_0.5x0.5.nc','topo_3d_0.9x1.25_c150322.nc','topo_3d_1.9x2.5_c150322.nc'};
scales = {'r0125','r025', 'r05', 'r1', 'r2'};

res = 1;
%% modis
scale = scales{res};
cols = col_alls{res};
res_v = res_vs{res};
res_h = res_hs{res};


lon = (-180+res_h/2):res_h: (180-res_h/2);
lat = (90-res_v/2):-res_v: (-90+res_v/2);

[lons,lats]=meshgrid(lon,lat);

%% 72 26 104 40
rows_start = floor((90-41)/res_v)-2;
cols_start = floor((71+180)/res_h)-2;
rows_end = ceil((90-23)/res_v)+2;
cols_end = ceil((106+180)/res_h)+2;

lats = lats(rows_start:rows_end, cols_start:cols_end);
lons = lons(rows_start:rows_end, cols_start:cols_end);



SINSL_COSAS = ncread([topDir topFilenames{res}], 'SINSL_COSAS');
SINSL_SINAS = ncread([topDir topFilenames{res}], 'SINSL_SINAS');
SKY_VIEW = ncread([topDir topFilenames{res}], 'SKY_VIEW');
STDEV_ELEV = ncread([topDir topFilenames{res}], 'STDEV_ELEV');
TERRAIN_CONFIG = ncread([topDir topFilenames{res}], 'TERRAIN_CONFIG');

SINSL_COSAS = flipud(SINSL_COSAS');
SINSL_SINAS = flipud(SINSL_SINAS');
SKY_VIEW = flipud(SKY_VIEW');
STDEV_ELEV = flipud(STDEV_ELEV');
TERRAIN_CONFIG = flipud(TERRAIN_CONFIG');




SINSL_COSAS = SINSL_COSAS(rows_start:rows_end, cols_start:cols_end);
SINSL_SINAS =  SINSL_SINAS(rows_start:rows_end, cols_start:cols_end);
SKY_VIEW =  SKY_VIEW(rows_start:rows_end, cols_start:cols_end);
STDEV_ELEV =  STDEV_ELEV(rows_start:rows_end, cols_start:cols_end);
TERRAIN_CONFIG =  TERRAIN_CONFIG(rows_start:rows_end, cols_start:cols_end);

%% resample
%% plot

colors = flipud(brewermap(15, 'Spectral'));
% colors = colors(2:end, :);
%colors = (brewermap(9, 'BrBG'));

%% mean_ELEV
figure;
colormap(colors)
set(gcf,'unit','normalized','position',[0.1,0.1,0.80,0.7]);
subplot('Position', [0.04 0.52 0.40 0.4]);
plot_global_map(lats, lons, SINSL_COSAS, -0.1, 0.1, '(a) sin(\alpha)\cdotcos(\beta)', colors, 1, 0);


hcb = colorbar;
hcb.Title.String = '';
hcb.Title.FontSize = 10;
hcb.Title.FontWeight = 'Bold';

x=get(hcb,'Position');
x(3)=0.02;
x(1)=0.45;
x(4)=0.4;
x(2)=0.52;

set(hcb,'Position',x);

set(gca, 'FontName', 'Time New Roman');
%% STDEV_ELEV
subplot( 'Position', [0.52 0.52 0.40 0.4]);
plot_global_map(lats, lons, SINSL_SINAS, -0.1, 0.1, '(b) sin(\alpha)\cdotsin(\beta)', colors, 0, 0);
hcb = colorbar;
hcb.Title.String = '';
hcb.Title.FontSize = 10;
hcb.Title.FontWeight = 'Bold';

x=get(hcb,'Position');
x(3)=0.02;
x(1)=0.935;
x(4)=0.4;
x(2)=0.52;

set(hcb,'Position',x)
set(gca, 'FontName', 'Time New Roman');


%% skyview faotor
subplot( 'Position', [0.04 0.05 0.40 0.4]);
plot_global_map(lats, lons, SKY_VIEW, 0.9, 1, '(c) Sky view factor', colors, 1, 1);
hcb = colorbar;
hcb.Title.String = '';
hcb.Title.FontSize = 10;
hcb.Title.FontWeight = 'Bold';

x=get(hcb,'Position');
x(3)=0.02;
x(1)=0.45;
x(4)=0.4;
x(2)=0.05;

set(hcb,'Position',x)
set(gca, 'FontName', 'Time New Roman');
%% CT

subplot( 'Position', [0.52 0.05 0.40 0.4]);
plot_global_map(lats, lons, TERRAIN_CONFIG, 0, 0.3, '(d) Terrain configuration factor', colors, 0, 1);
hcb = colorbar;
hcb.Title.String = '';
hcb.Title.FontSize = 10;
hcb.Title.FontWeight = 'Bold';

x=get(hcb,'Position');
x(3)=0.02;
x(1)=0.935;
x(4)=0.4;
x(2)=0.05;

set(hcb,'Position',x)
set(gca, 'FontName', 'Time New Roman');

print(gcf, '-dsvg', '-r300', '../improved_figures/figure_S1_top_factor.svg')

close all


