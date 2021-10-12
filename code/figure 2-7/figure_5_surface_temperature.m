
clc;
clear all;
close all;
%% lat lon
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40

scales = {'r0125','r025', 'r05', 'f09', 'f19'};

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
    
    
    %% plot
    colors = flipud(brewermap(15, 'Spectral'));
    colors_2 =  flipud(brewermap(15, 'RdBu'));
    
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.55/3*2]);
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
        Albedo_PP = mean_10_year_ELM_notop_FIRE_all;
        Albedo_3D = mean_10_year_ELM_top_FIRE_all;
        
        Albedo_PP = sqrt(sqrt(Albedo_PP./(5.67*1e-8)));
         Albedo_3D =sqrt(sqrt(Albedo_3D./(5.67*1e-8)));
        
        Albedo_abs_difference = Albedo_3D - Albedo_PP;
        Albedo_rel_difference = Albedo_abs_difference./Albedo_PP;
        
        min_values = [260 -1 -20];
        max_values = [320 1 20];
        
        %% plot 1
        ax1 = subplot('position', [0.06 + 0.9/4*(i-1) 0.5 0.2 0.45])
        colormap(ax1, colors);
        hold on
        if(i==1)
            plot_global_map(lats, lons, Albedo_PP, min_values(1), max_values(1),strcat(index, SeasonsNames{i}), colors,1, 0);
        else
            plot_global_map(lats, lons, Albedo_PP, min_values(1), max_values(1),strcat( index, SeasonsNames{i}), colors,0, 0);
        end
        
        if(i==1)
            ylabel({'PP',''})
        end
        
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'K';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.36;
            x(1)=0.955;
            x(2)=0.53;
            set(hcb,'Position',x)
        end
        set(gca,'fontsize',8,'fontname','time new roman')
        
        ax2 = subplot('position', [0.06 + 0.9/4*(i-1) 0.05 0.2 0.45])
        colormap(ax2, colors_2);
        hold on
        if(i==1)
            plot_global_map(lats, lons, Albedo_abs_difference, min_values(2), max_values(2),"", colors_2,1, 1);
        else
            plot_global_map(lats, lons, Albedo_abs_difference, min_values(2), max_values(2),"", colors_2,0, 1);
        end
        
        if(i==1)
            ylabel({'TOP-PP',''})
        end
        if(i==4)
            hcb = colorbar;
            hcb.Title.String = 'K';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.36;
            x(1)=0.955;
            x(2)=0.07;
            set(hcb,'Position',x)
        end
%         ax3 = subplot('position', [0.06 + 0.9/4*(i-1) 0.05 0.2 0.3])
%         colormap(ax3, colors_2);
%         hold on
%         if(i==1)
%             plot_global_map(lats, lons, Albedo_rel_difference*100, min_values(3), max_values(3),"", colors_2,1, 1);
%         else
%             plot_global_map(lats, lons, Albedo_rel_difference*100, min_values(3), max_values(3),"", colors_2,0, 1);
%         end
%         
%         if(i==1)
%             ylabel({'(TOP-PP)/PP',''})
%         end
%         if(i==4)
%             hcb = colorbar;
%             hcb.Title.String = '%';
%             hcb.Title.FontSize = 8;
%             hcb.Title.FontWeight = 'Bold';
%             x1=get(gca,'position');
%             x=get(hcb,'Position');
%             x(3)=0.012;
%             x(4)=0.23;
%             x(1)=0.955;
%             x(2)=0.07;
%             set(hcb,'Position',x)
%         end
        set(gca,'fontsize',8,'fontname','time new roman')
        
    end
    print(gcf, '-dsvg', '-r300', '../improved_figures/figure_12_surface_temperature.svg')
    
    close all
       
end
