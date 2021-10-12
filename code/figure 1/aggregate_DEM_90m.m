clear all;
close all;

%% aggregate
files = dir('*.tif');

dem_tmp = imread(files(1).name);
dem_1 = squeeze(dem_tmp(:,:,2));

dem_tmp = imread(files(2).name);
dem_2 = squeeze(dem_tmp(:,:,2));

dem_tmp = imread(files(3).name);
dem_3 = squeeze(dem_tmp(:,:,2));

dem_tmp = imread(files(4).name);
dem_4 = squeeze(dem_tmp(:,:,2));

dem_tmp = imread(files(5).name);
dem_5 = squeeze(dem_tmp(:,:,2));

dem_tmp = imread(files(6).name);
dem_6 = squeeze(dem_tmp(:,:,2));

DEM_all = [dem_1 dem_2 dem_3
    dem_4 dem_5 dem_6];

mean_DEM_0125 = nan(144, 280);
std_DEM_0125 = nan(144, 280);

%% to 0.125 degree
for i = 1:144
    for j = 1:280
        dem_tmp = DEM_all(((i-1)*125 + 1):(i*125), ((j-1)*125 + 1):(j*125));
        mean_DEM_0125(i,j) = nanmean(dem_tmp(:));
        std_DEM_0125(i,j) = nanstd(dem_tmp(:));
    end
end

%% save
save('slope_0125_mean_std.mat', 'mean_DEM_0125', 'std_DEM_0125');
    