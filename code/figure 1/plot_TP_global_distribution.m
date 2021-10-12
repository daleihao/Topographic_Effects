clc
clear all;
load('dem_0125_mean_std.mat');
%% lat lon
res_v = 0.125;
res_h = 0.125;
lon = (71+res_h/2):res_h: (106-res_h/2);
lat = (41-res_v/2):-res_v: (23 + res_v/2);
[lons,lats]=meshgrid(lon,lat);

%% resample
%% plot

colors = flipud(brewermap(15, 'Spectral'));
% colors = colors(2:end, :);
%colors = (brewermap(9, 'BrBG'));

%% mean_ELEV
figure;
colormap(colors)
set(gcf,'unit','normalized','position',[0.1,0.1,0.80,0.36]);
subplot('Position', [0.04 0.08 0.40 0.85]);
plot_global_map(lats, lons, mean_DEM_0125, 0, 6000, '(a) Mean of Elevation', colors, 1, 1);


hcb = colorbar;
hcb.Title.String = 'm';
hcb.Title.FontSize = 10;
hcb.Title.FontWeight = 'Bold';

x=get(hcb,'Position');
x(3)=0.02;
x(1)=0.455;
x(4)=0.8;
x(2)=0.08;

set(hcb,'Position',x);

set(gca, 'FontName', 'Time New Roman');
%% STDEV_ELEV
subplot( 'Position', [0.52 0.08 0.40 0.85]);
plot_global_map(lats, lons, std_DEM_0125, 0, 1000, '(b) Std of Elevation', colors, 0, 1);
hcb = colorbar;
hcb.Title.String = 'm';
hcb.Title.FontSize = 10;
hcb.Title.FontWeight = 'Bold';

x=get(hcb,'Position');
x(3)=0.02;
x(1)=0.935;
x(4)=0.8;
x(2)=0.08;

set(hcb,'Position',x)
set(gca, 'FontName', 'Time New Roman');

print(gcf, '-dpng', '-r300', '../figure_submitted/fig02.png')

close all


