
%% lat lon
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40

scales = {'r0125','r025', 'r05', 'r1', 'r2'};
scalenames = {'r0125','r025', 'r05', 'f09', 'f19'};

for res = 1:5
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
    
    if(res_v>0.5)
        tmp = SINSL_COSAS;
        SINSL_COSAS(:,1:cols/2) = tmp(:,cols/2+1:cols);
        SINSL_COSAS(:,cols/2+1:cols) = tmp(:,1:cols/2);
        
        tmp = SINSL_SINAS;
        SINSL_SINAS(:,1:cols/2) = tmp(:,cols/2+1:cols);
        SINSL_SINAS(:,cols/2+1:cols) = tmp(:,1:cols/2);
        
        tmp = SKY_VIEW;
        SKY_VIEW(:,1:cols/2) = tmp(:,cols/2+1:cols);
        SKY_VIEW(:,cols/2+1:cols) = tmp(:,1:cols/2);
        
        tmp = STDEV_ELEV;
        STDEV_ELEV(:,1:cols/2) = tmp(:,cols/2+1:cols);
        STDEV_ELEV(:,cols/2+1:cols) = tmp(:,1:cols/2);
        
        tmp = TERRAIN_CONFIG;
        TERRAIN_CONFIG(:,1:cols/2) = tmp(:,cols/2+1:cols);
        TERRAIN_CONFIG(:,cols/2+1:cols) = tmp(:,1:cols/2);
        
        
    end
    
    
    SINSL_COSAS = SINSL_COSAS(rows_start:rows_end, cols_start:cols_end);
    SINSL_SINAS =  SINSL_SINAS(rows_start:rows_end, cols_start:cols_end);
    SKY_VIEW =  SKY_VIEW(rows_start:rows_end, cols_start:cols_end);
    STDEV_ELEV =  STDEV_ELEV(rows_start:rows_end, cols_start:cols_end);
    TERRAIN_CONFIG =  TERRAIN_CONFIG(rows_start:rows_end, cols_start:cols_end);
    
    
    
    %% resample
    %% plot
    colors = flipud(brewermap(21, 'BrBg'));
    colors_2 =  flipud(brewermap(41, 'BrBg'));
    colors_2 = colors_2(21:end,:);
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.55,0.5]);
    set(gca, 'Position', [0.02 0.05 0.95 0.85])
    
    %% Albedo
    for i = 1:4
        
        load(['../variable_importance/' scale '_' SeasonsNames{i} '_data.mat']);
        Albedo_PP = mean_ELM_notop_Albedo_weighted_all;
        Albedo_3D = mean_ELM_top_Albedo_weighted_all;
        
        
        if(res_v>0.5)
        tmp = Albedo_PP;
        Albedo_PP(:,1:cols/2) = tmp(:,cols/2+1:cols);
        Albedo_PP(:,cols/2+1:cols) = tmp(:,1:cols/2);
        
        tmp = Albedo_3D;
        Albedo_3D(:,1:cols/2) = tmp(:,cols/2+1:cols);
        Albedo_3D(:,cols/2+1:cols) = tmp(:,1:cols/2); 
        
    end
        Albedo_difference = Albedo_3D - Albedo_PP;
        
        Albedo_PP =  Albedo_PP(rows_start:rows_end, cols_start:cols_end);
        Albedo_difference =  Albedo_difference(rows_start:rows_end, cols_start:cols_end);
        
        %% plot 1
        colormap(colors);
        hold on
        plot_global_map2(lats, lons, Albedo_difference./Albedo_PP, -0.2, 0.2, colors);
        %ylabel({'(3D-PP)/PP',''})
        colorbar
        title(scalenames{res})
        set(gca,'fontsize',15,'fontname','time new roman')
         print(gcf, '-dtiff', '-r600', [scale '_' SeasonsNames{i} '_Albedo_3D-PP.png'])
       t = Albedo_difference./Albedo_PP;
         save([scale '_' SeasonsNames{i} '_albedo_diff.mat'],'t');
    end
   close all

    
end
