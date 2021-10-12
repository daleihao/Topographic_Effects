
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
    
    %     figure;
    %     set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
    %     set(gca, 'Position', [0 0 1 1])
    
    
    for i = 1:1
        
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
        BSA_top_notop =top_BSA -  notop_BSA;
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        
        
        top_SNO = mean_10_year_ELM_top_FSNO_average_all;
        notop_SNO = mean_10_year_ELM_notop_FSNO_average_all;
        MODIS_SNO = mean_10_year_MODIS_SnowCover_all;
        
        SNO_difference = top_SNO - notop_SNO;
        SNO_notop_difference = notop_SNO - MODIS_SNO;
        SNO_top_difference = top_SNO - MODIS_SNO;
        SNO_delta_difference = abs(SNO_top_difference) - abs(SNO_notop_difference);
        SNO_top_notop =top_SNO -  notop_SNO;
        
        load('mean_elevation.mat');
        figure;
        set(gcf,'unit','normalized','position',[0.1,0.1,0.64,0.3]);
        set(gca, 'Position', [0 0 1 1])
        
        subplot('position', [0.58 0.2 0.4 0.79])
        hold on
        scatter(SNO_delta_difference(:), BSA_delta_difference(:), 10,'k','filled', 'MarkerFaceAlpha',0.2);
        box on
        [b1,bint,r,rint,stats] = regress(BSA_delta_difference(:), [ ones(size(SNO_delta_difference(:),1),1) SNO_delta_difference(:) ]);
        a = SNO_delta_difference(:);
        b = BSA_delta_difference(:);
        
        filter = ~isnan(a) & ~isnan(b);
        R = corrcoef(a(filter), b(filter))
        R = R(1,2);
        text(-0.14,0.135,['(b) R=' num2str(R,'%4.2f')],'fontsize',10,'fontname','time new roman','fontweight','bold')
        min_value = -0.15;
        max_value = 0.15;
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        
                ylim([-0.15 0.15])

        xlabel({'|\delta_{TOP}| - |\delta_{PP}| for snow cover fraction'})
        ylabel({'|\delta_{TOP}| - |\delta_{PP}| for direct albedo'})
        
        subplot('position', [0.1 0.2 0.4 0.79])
        hold on
        scatter(notop_SNO(:), BSA_delta_difference(:), 10,'k','filled', 'MarkerFaceAlpha',0.2)
         box on
        [b1,bint,r,rint,stats] = regress(BSA_delta_difference(:), [ ones(size(notop_SNO(:),1),1) notop_SNO(:) ]);
        a = notop_SNO(:);
        b = BSA_delta_difference(:);
        
        filter = ~isnan(a) & ~isnan(b);
        R = corrcoef(a(filter), b(filter))
        R = R(1,2);
        text(0.75,0.135,['(a) R=' num2str(R,'%4.2f')],'fontsize',10,'fontname','time new roman','fontweight','bold')
        min_value = 0;
        max_value = 1;
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        
        
        ylabel({'|\delta_{TOP}| - |\delta_{PP}| for direct albedo'})
                xlabel('PP snow cover fraction')

        ylim([-0.15 0.15])
        
        print(gcf, '-dsvg', '-r300', '../revised_figures/figure_11_relationship.svg')

    end
    
    close all
end
