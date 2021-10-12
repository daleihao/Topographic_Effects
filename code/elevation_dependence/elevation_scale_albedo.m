
clc;
clear all;
close all;


%% lat lon
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40

scales = {'r0125','r025', 'r05', 'f09', 'f19'};

ele_dir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/writting/topography_and_pft/data/elevation_data/';
%% plot
colors = flipud(brewermap(15, 'Spectral'));
colors_2 =  flipud(brewermap(15, 'RdBu'));

% figure;
% set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.62]);
% set(gca, 'Position', [0 0 1 1])

scale_1_all = [];
scale_2_all = [];
scale_3_all = [];
scale_4_all = [];
scale_5_all = [];

for res = 1:5
    
    
    
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
   mean_elevations = double(imread([ele_dir 'Topographic_Map_' scale '_mean.tif']));
    mean_elevation = squeeze(mean_elevations(:,:,1));   
    mean_slope = squeeze(mean_elevations(:,:,2));
    mean_elevation = mean_elevation(rows_start:rows_end, cols_start:cols_end);
    mean_slope = mean_slope(rows_start:rows_end, cols_start:cols_end);
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        Albedo_PP = mean_10_year_ELM_notop_Albedo_weighted_all;
        Albedo_3D = mean_10_year_ELM_top_Albedo_weighted_all;
        Albedo_abs_difference = Albedo_3D - Albedo_PP;
        Albedo_rel_difference = Albedo_abs_difference;%./Albedo_PP;
        
        %         Albedo_PP = mean_10_year_ELM_notop_FSA_all;
        %         Albedo_3D = mean_10_year_ELM_top_FSA_all;
        %         Albedo_abs_difference = Albedo_3D - Albedo_PP;
        %
        %         Albedo_rel_difference = Albedo_abs_difference./Albedo_PP;
        %
        %                 Albedo_PP = mean_10_year_ELM_notop_FSNO_average_all*100;
        %         Albedo_3D = mean_10_year_ELM_top_FSNO_average_all*100;
        %         Albedo_abs_difference = Albedo_3D - Albedo_PP;
        %         Albedo_rel_difference = Albedo_abs_difference;
        
        
        %         switch res
        %             case 1
        %                 scale_1_all = Albedo_rel_difference;
        %             case 2
        %                 scale_2_all = Albedo_rel_difference;
        %             case 3
        %                 scale_3_all = Albedo_rel_difference;
        %             case 4
        %                 scale_4_all = Albedo_rel_difference;
        %             case 5
        %                 scale_5_all = Albedo_rel_difference;
        %         end
        
        
          filters = mean_elevation<1500 & mean_slope>0;
        b1 = (Albedo_rel_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>0;
        b2 = (Albedo_rel_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>0;
        b3 = (Albedo_rel_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>0;
        b4 = (Albedo_rel_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>0;
        b5 = (Albedo_rel_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
        
        if(i==1)
            group_data = [group bdata];
        else
            group_data = [group_data bdata];
        end
    end
    
   save(['abs_albedo_' scale '.mat' ],'group_data');
end


% print(gcf, '-dsvg', '-r300', '../../results_revise/test_figure_elevation_scale_albedo.svg')
% close all

