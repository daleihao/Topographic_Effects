
%% lat lon
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40
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
    rows_start = floor((90-41)/res_v)-2;
    cols_start = floor((71+180)/res_h)-2;
    rows_end = ceil((90-23)/res_v)+2;
    cols_end = ceil((106+180)/res_h)+2;
    
    lats = lats(rows_start:rows_end, cols_start:cols_end);
    lons = lons(rows_start:rows_end, cols_start:cols_end);
    
    
    
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
        
        
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        colormap(ax1, colors);
        
        hold on
        if i==1
            plot_global_map(lats, lons, BSA_notop_difference, -0.2, 0.2,strcat(index, SeasonsNames{i}), colors, 1, 0);
        else
            plot_global_map(lats, lons, BSA_notop_difference, -0.2, 0.2,strcat(index, SeasonsNames{i}), colors, 0, 0);
        end
        
        if(i==1)
            ylabel({'\delta_{PP}',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'Unitless';
            hcb.Title.FontSize = 7;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.30;
            x(1)=0.955;
            x(2)=0.52;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        
        ax2 = subplot('position', [0.06 + 0.88/4*(i-1) 0.07 0.22 0.38])
        colormap(ax2, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, BSA_delta_difference, -0.1, 0.1,"", colors, 1, 1);
        else
            plot_global_map(lats, lons, BSA_delta_difference, -0.1, 0.1,"", colors, 0, 1);
        end
        if(i==1)
            ylabel({'|\delta_{TOP}| - |\delta_{PP}|',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'Unitless';
            hcb.Title.FontSize = 7;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.3;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_2_BSA.svg')
    close all
    
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
        
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        colormap(ax1, colors);
        
        hold on
        if i==1
            plot_global_map(lats, lons, BSA_notop_difference, -0.2, 0.2,strcat(index, SeasonsNames{i}), colors, 1, 0);
        else
            plot_global_map(lats, lons, BSA_notop_difference, -0.2, 0.2,strcat(index, SeasonsNames{i}), colors, 0, 0);
        end
        
        if(i==1)
            ylabel({'\delta_{PP}',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'Unitless';
            hcb.Title.FontSize = 7;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.30;
            x(1)=0.955;
            x(2)=0.52;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        
        ax2 = subplot('position', [0.06 + 0.88/4*(i-1) 0.07 0.22 0.38])
        colormap(ax2, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, BSA_delta_difference, -0.1, 0.1,"", colors, 1, 1);
        else
            plot_global_map(lats, lons, BSA_delta_difference, -0.1, 0.1,"", colors, 0, 1);
        end
        if(i==1)
            ylabel({'|\delta_{TOP}| - |\delta_{PP}|',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'Unitless';
            hcb.Title.FontSize = 7;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.3;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    
    
    
    %% latent heat flux
    
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_3_WSA.svg')
    close all
    
    
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
        
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        colormap(ax1, colors);
        
        hold on
        if i==1
            plot_global_map(lats, lons, BSA_notop_difference, -30, 30,strcat(index, SeasonsNames{i}), colors, 1, 0);
        else
            plot_global_map(lats, lons, BSA_notop_difference, -30, 30,strcat(index, SeasonsNames{i}), colors, 0, 0);
        end
        
        if(i==1)
            ylabel({'\delta_{PP}',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'W/m^2';
            hcb.Title.FontSize = 7;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.30;
            x(1)=0.955;
            x(2)=0.52;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        
        ax2 = subplot('position', [0.06 + 0.88/4*(i-1) 0.07 0.22 0.38])
        colormap(ax2, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, BSA_delta_difference, -5, 5,"", colors, 1, 1);
        else
            plot_global_map(lats, lons, BSA_delta_difference, -5, 5,"", colors, 0, 1);
        end
        if(i==1)
            ylabel({'|\delta_{TOP}| - |\delta_{PP}|',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'W/m^2';
            hcb.Title.FontSize = 7;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.3;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_7_latent_heat.svg')
    close all
    
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
        
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        colormap(ax1, colors);
        
        hold on
        if i==1
            plot_global_map(lats, lons, BSA_notop_difference, -10, 10,strcat(index, SeasonsNames{i}), colors, 1, 0);
        else
            plot_global_map(lats, lons, BSA_notop_difference, -10, 10,strcat(index, SeasonsNames{i}), colors, 0, 0);
        end
        
        if(i==1)
            ylabel({'\delta_{PP}',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'K';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.30;
            x(1)=0.955;
            x(2)=0.52;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        
        ax2 = subplot('position', [0.06 + 0.88/4*(i-1) 0.07 0.22 0.38])
        colormap(ax2, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, BSA_delta_difference, -1, 1,"", colors, 1, 1);
        else
            plot_global_map(lats, lons, BSA_delta_difference, -1, 1,"", colors, 0, 1);
        end
        if(i==1)
            ylabel({'|\delta_{TOP}| - |\delta_{PP}|',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'K';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.3;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_5_daytime_temperature.svg')
    close all
    
    
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
        
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        colormap(ax1, colors);
        
        hold on
        if i==1
            plot_global_map(lats, lons, BSA_notop_difference, -10, 10,strcat(index, SeasonsNames{i}), colors, 1, 0);
        else
            plot_global_map(lats, lons, BSA_notop_difference, -10, 10,strcat(index, SeasonsNames{i}), colors, 0, 0);
        end
        
        if(i==1)
            ylabel({'\delta_{PP}',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'K';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.30;
            x(1)=0.955;
            x(2)=0.52;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        
        ax2 = subplot('position', [0.06 + 0.88/4*(i-1) 0.07 0.22 0.38])
        colormap(ax2, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, BSA_delta_difference, -1, 1,"", colors, 1, 1);
        else
            plot_global_map(lats, lons, BSA_delta_difference, -1, 1,"", colors, 0, 1);
        end
        if(i==1)
            ylabel({'|\delta_{TOP}| - |\delta_{PP}|',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'K';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.3;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_6_nighttime_temperature.svg')
    close all
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
        
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.88/4*(i-1) 0.50 0.22 0.38])
        colormap(ax1, colors);
        
        hold on
        if i==1
            plot_global_map(lats, lons, BSA_notop_difference, -30, 30,strcat(index, SeasonsNames{i}), colors, 1, 0);
        else
            plot_global_map(lats, lons, BSA_notop_difference, -30, 30,strcat(index, SeasonsNames{i}), colors, 0, 0);
        end
        
        if(i==1)
            ylabel({'\delta_{PP}',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '%';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.30;
            x(1)=0.955;
            x(2)=0.52;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        
        ax2 = subplot('position', [0.06 + 0.88/4*(i-1) 0.07 0.22 0.38])
        colormap(ax2, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, BSA_delta_difference, -10, 10,"", colors, 1, 1);
        else
            plot_global_map(lats, lons, BSA_delta_difference, -10, 10,"", colors, 0, 1);
        end
        if(i==1)
            ylabel({'|\delta_{TOP}| - |\delta_{PP}|',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = '%';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.3;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_4_snow_cover.svg')
    close all
end
