
%% lat lon
topDir = 'C:\Users\haod776\OneDrive - PNNL\Documents\work\proposal_&_code\UCLA_3D_Topo_Data\UCLA_3D_Topo_Data\';
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40
topFilenames = {'topo_3d_0.125x0.125.nc','topo_3d_0.25x0.25.nc','topo_3d_0.5x0.5.nc','topo_3d_0.9x1.25_c150322.nc','topo_3d_1.9x2.5_c150322.nc'};
scales = {'r0125','r025', 'r05', 'r1', 'r2'};

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
    rows_start = round((90-41)/res_v);
    cols_start = round((72+180)/res_h);
    rows_end = round((90-23)/res_v);
    cols_end = round((106+180)/res_h);
    
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
    
    
    data = imread('Topographic_Map_0_125.tif');
    meanslope = data(:,:,2);
    meanslope = meanslope(rows_start:rows_end, cols_start:cols_end);
    
    %% resample
    %% plot
    colors = flipud(brewermap(21, 'BrBg'));
    colors_2 =  flipud(brewermap(41, 'BrBg'));
    colors_2 = colors_2(21:end,:);
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.55]);
    set(gca, 'Position', [0 0 1 1])
    
    %% Albedo
    for i = 1:4
        
        load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
        Albedo_PP = mean_ELM_notop_Albedo_weighted_all;
        Albedo_3D = mean_ELM_top_Albedo_weighted_all;
        Albedo_difference = Albedo_3D - Albedo_PP;
        
        Albedo_PP =  Albedo_PP(rows_start:rows_end, cols_start:cols_end);
        Albedo_difference =  Albedo_difference(rows_start:rows_end, cols_start:cols_end);
        
        %% plot 1
        ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
        colormap(ax1, colors_2);
        hold on
        plot_global_map2(lats, lons, Albedo_PP, 0, 1, colors);
        if(i==1)
            ylabel({'PP',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.26;
            x(1)=0.95;
            x(2)=0.67;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        title(SeasonsNames{i})
        
        ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
         colormap(ax2, colors);
        hold on
        plot_global_map2(lats, lons, Albedo_difference, -0.1, 0.1, colors);
        if(i==1)
            ylabel({'3D-PP',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.26;
            x(1)=0.95;
            x(2)=0.37;
            set(hcb,'Position',x)
        end
        ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
        colormap(ax3, colors);
        hold on
        plot_global_map2(lats, lons, Albedo_difference./Albedo_PP, -0.2, 0.2, colors);
        
        if(i==1)
            ylabel({'(3D-PP)/PP',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.26;
            x(1)=0.95;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    print(gcf, '-dtiff', '-r600', 'Albedo_3D-PP.png')
    
%     %% Snow Cover
%     for i = 1:4
%         
%         load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
%         FSNO_PP = mean_ELM_notop_FSNO_average_all;
%         FSNO_3D = mean_ELM_top_FSNO_average_all;
%         FSNO_difference = FSNO_3D - FSNO_PP;
%         
%         FSNO_PP =  FSNO_PP(rows_start:rows_end, cols_start:cols_end);
%         FSNO_difference =  FSNO_difference(rows_start:rows_end, cols_start:cols_end);
%         
%         %% plot 1
%         ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
%         colormap(ax1, colors_2);
%         hold on
%         plot_global_map2(lats, lons, FSNO_PP, 0, 1, colors);
%         if(i==1)
%             ylabel({'PP',''})
%         end
%         
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.67;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         title(SeasonsNames{i})
%         
%         ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
%          colormap(ax2, colors);
%         hold on
%         plot_global_map2(lats, lons, FSNO_difference, -0.1, 0.1, colors);
%         if(i==1)
%             ylabel({'3D-PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.37;
%             set(hcb,'Position',x)
%         end
%         ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
%         colormap(ax3, colors);
%         hold on
%         plot_global_map2(lats, lons, FSNO_difference./FSNO_PP, -0.2, 0.2, colors);
%         
%         if(i==1)
%             ylabel({'(3D-PP)/PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.07;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         
%     end
%     print(gcf, '-dtiff', '-r600', 'FSNO_3D-PP.png')
%     
    
%      %% surface temperature
%     for i = 1:4
%         
%         load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
%         ST_PP = mean_ELM_notop_ST_all;
%         ST_3D = mean_ELM_top_ST_all;
%         ST_difference = ST_3D - ST_PP;
%         
%         ST_PP =  ST_PP(rows_start:rows_end, cols_start:cols_end);
%         ST_difference =  ST_difference(rows_start:rows_end, cols_start:cols_end);
%         
%         %% plot 1
%         ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
%         colormap(ax1, colors_2);
%         hold on
%         plot_global_map2(lats, lons, ST_PP, 260, 320, colors);
%         if(i==1)
%             ylabel({'PP',''})
%         end
%         
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.67;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         title(SeasonsNames{i})
%         
%         ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
%          colormap(ax2, colors);
%         hold on
%         plot_global_map2(lats, lons, ST_difference, -1, 1, colors);
%         if(i==1)
%             ylabel({'3D-PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.37;
%             set(hcb,'Position',x)
%         end
%         ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
%         colormap(ax3, colors);
%         hold on
%         plot_global_map2(lats, lons, ST_difference./ST_PP, -0.2, 0.2, colors);
%         
%         if(i==1)
%             ylabel({'(3D-PP)/PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.07;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         
%     end
%     print(gcf, '-dtiff', '-r600', 'ST_3D-PP.png')
    
%      %% net radiation
%     for i = 1:4
%         
%         load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
%         netradiation_PP = mean_ELM_notop_netradiation_all;
%         netradiation_3D = mean_ELM_top_netradiation_all;
%         netradiation_difference = netradiation_3D - netradiation_PP;
%         
%         netradiation_PP =  netradiation_PP(rows_start:rows_end, cols_start:cols_end);
%         netradiation_difference =  netradiation_difference(rows_start:rows_end, cols_start:cols_end);
%         
%         %% plot 1
%         ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
%         colormap(ax1, colors_2);
%         hold on
%         plot_global_map2(lats, lons, netradiation_PP, 0, 400, colors);
%         if(i==1)
%             ylabel({'PP',''})
%         end
%         
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.67;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         title(SeasonsNames{i})
%         
%         ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
%          colormap(ax2, colors);
%         hold on
%         plot_global_map2(lats, lons, netradiation_difference, -20, 20, colors);
%         if(i==1)
%             ylabel({'3D-PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.37;
%             set(hcb,'Position',x)
%         end
%         ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
%         colormap(ax3, colors);
%         hold on
%         plot_global_map2(lats, lons, netradiation_difference./netradiation_PP, -0.2, 0.2, colors);
%         
%         if(i==1)
%             ylabel({'(3D-PP)/PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.07;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         
%     end
%     print(gcf, '-dtiff', '-r600', 'netradiation_3D-PP.png')

%  %% net radiation
%     for i = 1:4
%         
%         load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
%         LH_PP = mean_ELM_notop_LH_all;
%         LH_3D = mean_ELM_top_LH_all;
%         LH_difference = LH_3D - LH_PP;
%         
%         LH_PP =  LH_PP(rows_start:rows_end, cols_start:cols_end);
%         LH_difference =  LH_difference(rows_start:rows_end, cols_start:cols_end);
%         
%         %% plot 1
%         ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
%         colormap(ax1, colors_2);
%         hold on
%         plot_global_map2(lats, lons, LH_PP, 0, 100, colors);
%         if(i==1)
%             ylabel({'PP',''})
%         end
%         
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.67;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         title(SeasonsNames{i})
%         
%         ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
%          colormap(ax2, colors);
%         hold on
%         plot_global_map2(lats, lons, LH_difference, -10, 10, colors);
%         if(i==1)
%             ylabel({'3D-PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.37;
%             set(hcb,'Position',x)
%         end
%         ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
%         colormap(ax3, colors);
%         hold on
%         plot_global_map2(lats, lons, LH_difference./LH_PP, -0.2, 0.2, colors);
%         
%         if(i==1)
%             ylabel({'(3D-PP)/PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.07;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         
%     end
%     print(gcf, '-dtiff', '-r600', 'LH_3D-PP.png')
%     
%     %% net radiation
%     for i = 1:4
%         
%         load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
%         FSH_PP = mean_ELM_notop_FSH_all;
%         FSH_3D = mean_ELM_top_FSH_all;
%         FSH_difference = FSH_3D - FSH_PP;
%         
%         FSH_PP =  FSH_PP(rows_start:rows_end, cols_start:cols_end);
%         FSH_difference =  FSH_difference(rows_start:rows_end, cols_start:cols_end);
%         
%         %% plot 1
%         ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
%         colormap(ax1, colors_2);
%         hold on
%         plot_global_map2(lats, lons, FSH_PP, 0, 100, colors);
%         if(i==1)
%             ylabel({'PP',''})
%         end
%         
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.67;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         title(SeasonsNames{i})
%         
%         ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
%          colormap(ax2, colors);
%         hold on
%         plot_global_map2(lats, lons, FSH_difference, -10, 10, colors);
%         if(i==1)
%             ylabel({'3D-PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.37;
%             set(hcb,'Position',x)
%         end
%         ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
%         colormap(ax3, colors);
%         hold on
%         plot_global_map2(lats, lons, FSH_difference./FSH_PP, -0.2, 0.2, colors);
%         
%         if(i==1)
%             ylabel({'(3D-PP)/PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.26;
%             x(1)=0.95;
%             x(2)=0.07;
%             set(hcb,'Position',x)
%         end
%         set(gca,'fontsize',8,'fontname','time new roman')
%         
%     end
%     print(gcf, '-dtiff', '-r600', 'FSH_3D-PP.png')
    %% snow depth
    for i = 1:4
        
        load(['../variable_importance/' scale '_' SeasonsNames{i} '_alldata.mat']);
        SNOWDP_PP = mean_ELM_notop_SNOWDP_average_all;
        SNOWDP_3D = mean_ELM_top_SNOWDP_average_all;
        SNOWDP_difference = SNOWDP_3D - SNOWDP_PP;
        
        SNOWDP_PP =  SNOWDP_PP(rows_start:rows_end, cols_start:cols_end);
        SNOWDP_difference =  SNOWDP_difference(rows_start:rows_end, cols_start:cols_end);
        
        %% plot 1
        ax1 = subplot('position', [0.08 + 0.9/4*(i-1) 0.65 0.17 0.3])
        colormap(ax1, colors_2);
        hold on
        plot_global_map2(lats, lons, SNOWDP_PP, 0, 0.5, colors);
        if(i==1)
            ylabel({'PP',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.26;
            x(1)=0.95;
            x(2)=0.67;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        title(SeasonsNames{i})
        
        ax2 = subplot('position', [0.08 + 0.9/4*(i-1) 0.35 0.17 0.3])
         colormap(ax2, colors);
        hold on
        plot_global_map2(lats, lons, SNOWDP_difference, -0.1, 0.1, colors);
        if(i==1)
            ylabel({'3D-PP',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.26;
            x(1)=0.95;
            x(2)=0.37;
            set(hcb,'Position',x)
        end
        ax3 = subplot('position', [0.08 + 0.9/4*(i-1) 0.05 0.17 0.3])
        colormap(ax3, colors);
        hold on
        plot_global_map2(lats, lons, SNOWDP_difference./SNOWDP_PP, -0.2, 0.2, colors);
        
        if(i==1)
            ylabel({'(3D-PP)/PP',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.26;
            x(1)=0.95;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    print(gcf, '-dtiff', '-r600', 'SNOWDP_3D-PP.png')
    
end
