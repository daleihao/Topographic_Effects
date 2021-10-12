
clc;
clear all;
close all;
%% lat lon
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40

scales = {'r0125','r025', 'r05', 'f09', 'f19'};

%% plot
colors = flipud(brewermap(15, 'Spectral'));
colors_2 =  flipud(brewermap(15, 'RdBu'));

figure;
set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.62]);
set(gca, 'Position', [0 0 1 1])

scale_1_all = [];
scale_2_all = [];
scale_3_all = [];
scale_4_all = [];
scale_5_all = [];

for res = 1:5
    
    switch res
        case 1
            index = "(a) ";
        case 2
            index = "(b) ";
        case 3
            index = "(c) ";
        case 4
            index = "(d) ";
        case 5
            index = "(e) ";
    end
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
    
    
    
    
    for i = 1:1
        
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        Albedo_PP = mean_10_year_ELM_notop_FSH_all;
        Albedo_3D = mean_10_year_ELM_top_FSH_all;
        Albedo_abs_difference = Albedo_3D - Albedo_PP;
        Albedo_rel_difference = Albedo_abs_difference./Albedo_PP;
        
        
        switch res
            case 1
                scale_1_all = Albedo_rel_difference;
            case 2
                scale_2_all = Albedo_rel_difference;
            case 3
                scale_3_all = Albedo_rel_difference;
            case 4
                scale_4_all = Albedo_rel_difference;
            case 5
                scale_5_all = Albedo_rel_difference;
        end
        
        row_tmp = ceil(res/2);
        col_tmp = res - (row_tmp - 1)*2;
        ax3 = subplot('position', [0.06 + 0.9/2*(col_tmp-1) 0.05 + 0.3*(3-row_tmp) 0.4 0.3]);
        colormap(ax3, colors_2);
        hold on
        if row_tmp<3
            if(col_tmp==1)
                plot_global_map(lats, lons, Albedo_rel_difference*100, -20, 20,strcat(index, scales{res}), colors_2,1, 0);
            else
                plot_global_map(lats, lons, Albedo_rel_difference*100, -20, 20,strcat(index, scales{res}), colors_2,0, 0);
            end
        else
            if(col_tmp==1)
                plot_global_map(lats, lons, Albedo_rel_difference*100, -20, 20,strcat(index, scales{res}), colors_2,1, 1);
            else
                plot_global_map(lats, lons, Albedo_rel_difference*100, -20, 20,strcat(index, scales{res}), colors_2,0, 0);
            end
        end        
        if(res==1 || res==3 || res==5)
            ylabel({'(TOP-PP)/PP',''})
        end
        if(res==2 || res == 4)
            hcb = colorbar;
            hcb.Title.String = '%';
            hcb.Title.FontSize = 8;
            hcb.Title.FontWeight = 'Bold';
            x1=get(gca,'position');
            x=get(hcb,'Position');
            x(3)=0.012;
            x(4)=0.23;
            x(1)=0.94;
            x(2)=0.07+0.3*(3 - row_tmp);
            set(hcb,'Position',x)
        end
        
        %         if(res==5)
        %             hcb = colorbar;
        %             hcb.Title.String = '%';
        %             hcb.Title.FontSize = 8;
        %             hcb.Title.FontWeight = 'Bold';
        %             x=get(hcb,'Position');
        %             x(3)=0.012;
        %             x(4)=0.23;
        %             x(1)=0.955;
        %             x(2)=0.07;
        %             set(hcb,'Position',x)
        %         end
        set(gca,'fontsize',8,'fontname','time new roman')
    end
    
end


%% plot hist
col_tmp = 2;
row_tmp = 3;
ax3 = subplot('position', [0.06 + 0.9/2*(col_tmp-1) 0.08 + 0.3*(3-row_tmp) 0.4 0.24]);
hold on
[f_tmp,y_tmp] = histcounts(scale_5_all(:), 60,'BinLimits',[-0.3 0.3],'Normalization','probability');
y_tmp = (y_tmp(1:(end-1))+0.005)*100;
yyaxis right
plot(y_tmp,f_tmp*100, 'r-','LineWidth',0.8)

[f_tmp,y_tmp] = histcounts(scale_4_all(:), 60,'BinLimits',[-0.3 0.3],'Normalization','probability');
y_tmp = (y_tmp(1:(end-1))+0.005)*100;
yyaxis right
plot(y_tmp,f_tmp*100, 'y-','LineWidth',0.8)
[f_tmp,y_tmp] = histcounts(scale_3_all(:), 60,'BinLimits',[-0.3 0.3],'Normalization','probability');
y_tmp = (y_tmp(1:(end-1))+0.005)*100;
yyaxis right
plot(y_tmp,f_tmp*100, 'c-','LineWidth',0.8)
[f_tmp,y_tmp] = histcounts(scale_2_all(:), 60,'BinLimits',[-0.3 0.3],'Normalization','probability');
y_tmp = (y_tmp(1:(end-1))+0.005)*100;
yyaxis right
plot(y_tmp,f_tmp*100, 'b-','LineWidth',0.8)
[f_tmp,y_tmp] = histcounts(scale_1_all(:), 60,'BinLimits',[-0.3 0.3],'Normalization','probability');
y_tmp = (y_tmp(1:(end-1))+0.005)*100;
yyaxis right
plot(y_tmp,f_tmp*100, 'm-','LineWidth',0.8)
ylim([-0.01 30])
xlim([-20 20])
ylabel('Frequency (%)')
xlabel('(TOP-PP)/PP (%)')
box on

plot([0 0], [0 80], 'k--')
legend(fliplr(scales), 'Location','northwest');
ax = gca;
ax.YColor = 'k';
yyaxis left
ax.YTick = [];
ax.YColor = 'k';

title_text = "(f)";
if title_text ~= ""
    t = title(title_text,'fontsize',10, 'fontweight', 'bold');
    set(t, 'horizontalAlignment', 'left');
    set(t, 'units', 'normalized');
    h1 = get(t, 'position');
    set(t, 'position', [0 h1(2) h1(3)]);
end


print(gcf, '-dsvg', '-r300', '../revised_figures/figure_S5_sensible_flux.svg')
close all

