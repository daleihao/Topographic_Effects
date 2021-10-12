
%% lat lon
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40
scales = {'r0125','r025', 'r05', 'r1', 'r2'};

ele_dir = 'C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/writting/topography_and_pft/data/elevation_data/';

for res = 1:1
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
    
    mean_elevations = double(imread([ele_dir 'Topographic_Map_' scale '_mean.tif']));
    mean_elevation = squeeze(mean_elevations(:,:,1));   
    mean_slope = squeeze(mean_elevations(:,:,2));
    mean_elevation = mean_elevation(rows_start:rows_end, cols_start:cols_end);
    mean_slope = mean_slope(rows_start:rows_end, cols_start:cols_end);

    
    %% resample
    %% plot
    colors = flipud(brewermap(15, 'RdBu'));
    
    
    %% BSA
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    set(gca, 'Position', [0 0 1 1])
    
    
    for i = 1:4
        
        switch i
            case 1
                index = "(a) ";
            case 2
                index = "(b) ";
            case 3
                index = "(c) ";
            case 4
                index = "(d) ";
        end
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_BSA = mean_10_year_ELM_top_BSA_all;
        notop_BSA = mean_10_year_ELM_notop_BSA_all;
        MODIS_BSA = mean_10_year_MODIS_BSA_all;
        
        
        BSA_notop_difference = notop_BSA - MODIS_BSA;
        BSA_top_difference = top_BSA - MODIS_BSA;
        BSA_delta_difference = abs(BSA_top_difference) - abs(BSA_notop_difference);
        
BSA_delta_difference = BSA_notop_difference;
        
              filters = mean_elevation<1500 & mean_slope>1;
        b1 = (BSA_delta_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>1;
        b2 = (BSA_delta_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>1;
        b3 = (BSA_delta_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>1;
        b4 = (BSA_delta_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>1;
        b5 = (BSA_delta_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
 
       nanmean(b1)
         nanmean(b2)
         nanmean(b3)
         nanmean(b4)
         nanmean(b5)
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        boxplot(bdata, group)
       ylim([-0.2 0.2]) 


    end
    
  
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    set(gca, 'Position', [0 0 1 1])
    
    %% WSA
    for i = 1:4
        
        switch i
            case 1
                index = "(a) ";
            case 2
                index = "(b) ";
            case 3
                index = "(c) ";
            case 4
                index = "(d) ";
        end
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_BSA = mean_10_year_ELM_top_WSA_all;
        notop_BSA = mean_10_year_ELM_notop_WSA_all;
        MODIS_BSA = mean_10_year_MODIS_WSA_all;
        
        BSA_notop_difference = notop_BSA - MODIS_BSA;
        BSA_top_difference = top_BSA - MODIS_BSA;
        BSA_delta_difference = abs(BSA_top_difference) - abs(BSA_notop_difference);
        BSA_delta_difference = BSA_notop_difference;

               filters = mean_elevation<1500 & mean_slope>1;
        b1 = (BSA_delta_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>1;
        b2 = (BSA_delta_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>1;
        b3 = (BSA_delta_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>1;
        b4 = (BSA_delta_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>1;
        b5 = (BSA_delta_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
 
   
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
               boxplot(bdata, group)
  ylim([-0.2 0.2]) 
        
    end
    
    
    
    %% latent heat flux
    
  
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        switch i
            case 1
                index = "(a) ";
            case 2
                index = "(b) ";
            case 3
                index = "(c) ";
            case 4
                index = "(d) ";
        end
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_BSA = mean_10_year_ELM_top_LH_all;
        notop_BSA = mean_10_year_ELM_notop_LH_all;
        MODIS_BSA = mean_10_year_MODIS_LatentHeatFlux_all;
        
        BSA_notop_difference = notop_BSA - MODIS_BSA;
        BSA_top_difference = top_BSA - MODIS_BSA;
        BSA_delta_difference = abs(BSA_top_difference) - abs(BSA_notop_difference);
        BSA_delta_difference = BSA_notop_difference;

              filters = mean_elevation<1500 & mean_slope>1;
        b1 = (BSA_delta_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>1;
        b2 = (BSA_delta_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>1;
        b3 = (BSA_delta_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>1;
        b4 = (BSA_delta_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>1;
        b5 = (BSA_delta_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
 
        

        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
                      boxplot(bdata, group)
 ylim([-20 20]) 

    end
    
    
    %% surface temperature
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        switch i
            case 1
                index = "(a) ";
            case 2
                index = "(b) ";
            case 3
                index = "(c) ";
            case 4
                index = "(d) ";
        end
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_BSA = mean_10_year_ELM_top_daytimeST_all;
        notop_BSA = mean_10_year_ELM_notop_daytimeST_all;
        MODIS_BSA = mean_10_year_MODIS_daytimeST_all;
        
        BSA_notop_difference = notop_BSA - MODIS_BSA;
        BSA_top_difference = top_BSA - MODIS_BSA;
        BSA_delta_difference = abs(BSA_top_difference) - abs(BSA_notop_difference);
        BSA_delta_difference = BSA_notop_difference;

                      filters = mean_elevation<1500 & mean_slope>1;
        b1 = (BSA_delta_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>1;
        b2 = (BSA_delta_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>1;
        b3 = (BSA_delta_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>1;
        b4 = (BSA_delta_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>1;
        b5 = (BSA_delta_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
 
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
                      boxplot(bdata, group)
 ylim([-10 10]) 

    end
    
    
    
     %% surface temperature
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        switch i
            case 1
                index = "(a) ";
            case 2
                index = "(b) ";
            case 3
                index = "(c) ";
            case 4
                index = "(d) ";
        end
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_BSA = mean_10_year_ELM_top_nighttimeST_all;
        notop_BSA = mean_10_year_ELM_notop_nighttimeST_all;
        MODIS_BSA = mean_10_year_MODIS_nighttimeST_all;
        
        BSA_notop_difference = notop_BSA - MODIS_BSA;
        BSA_top_difference = top_BSA - MODIS_BSA;
        BSA_delta_difference = abs(BSA_top_difference) - abs(BSA_notop_difference);
        BSA_delta_difference = BSA_notop_difference;

                filters = mean_elevation<1500 & mean_slope>1;
        b1 = (BSA_delta_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>1;
        b2 = (BSA_delta_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>1;
        b3 = (BSA_delta_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>1;
        b4 = (BSA_delta_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>1;
        b5 = (BSA_delta_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
 
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
                     boxplot(bdata, group)
 ylim([-10 10])
        
    end
    
    %% snow cover
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        switch i
            case 1
                index = "(a) ";
            case 2
                index = "(b) ";
            case 3
                index = "(c) ";
            case 4
                index = "(d) ";
        end
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_BSA = mean_10_year_ELM_top_FSNO_average_all*100;
        notop_BSA = mean_10_year_ELM_notop_FSNO_average_all*100;
        MODIS_BSA = mean_10_year_MODIS_SnowCover_all*100;
        
        BSA_notop_difference = notop_BSA - MODIS_BSA;
        BSA_top_difference = top_BSA - MODIS_BSA;
        BSA_delta_difference = abs(BSA_top_difference) - abs(BSA_notop_difference);
        BSA_delta_difference = BSA_notop_difference;

               filters = mean_elevation<1500 & mean_slope>1;
        b1 = (BSA_delta_difference(filters));
        filters = mean_elevation>=1500 & mean_elevation<2500 & mean_slope>1;
        b2 = (BSA_delta_difference(filters));
        filters = mean_elevation>=2500 & mean_elevation<3500 & mean_slope>1;
        b3 = (BSA_delta_difference(filters));
        filters = mean_elevation>=3500 & mean_elevation<4500 & mean_slope>1;
        b4 = (BSA_delta_difference(filters));
        filters = mean_elevation>=4500 & mean_slope>1;
        b5 = (BSA_delta_difference(filters));
        bdata = [b1; b2; b3; b4; b5];
        group = [1*ones(size(b1)); 2*ones(size(b2)); 3*ones(size(b3)); 4*ones(size(b4)); 5*ones(size(b5))];
 
        
           nanmean(b1)
         nanmean(b2)
         nanmean(b3)
         nanmean(b4)
         nanmean(b5)
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
                       boxplot(bdata, group)
 ylim([-20 20])
    end
    
end
