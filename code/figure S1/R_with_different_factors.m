
%% lat lon
topDir = 'C:\Users\haod776\OneDrive - PNNL\Documents\work\proposal_&_code\UCLA_3D_Topo_Data\UCLA_3D_Topo_Data\';
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

Rs = zeros(6, 4);
res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40
topFilenames = {'topo_3d_0.125x0.125.nc','topo_3d_0.25x0.25.nc','topo_3d_0.5x0.5.nc','topo_3d_0.9x1.25_c150322.nc','topo_3d_1.9x2.5_c150322.nc'};
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
    
    
    
    %% resample
    %% plot
    %% plotdif
    
    
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
    
    
    range = 50;
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_derived = mean_10_year_ELM_top_Albedo_weighted_all;
        notop_derived = mean_10_year_ELM_notop_Albedo_weighted_all;
        
        %         if(res_v>0.5)
        %             tmp = top_derived;
        %             top_derived(:,1:cols/2) = tmp(:,cols/2+1:cols);
        %             top_derived(:,cols/2+1:cols) = tmp(:,1:cols/2);
        %             tmp = notop_derived;
        %             notop_derived(:,1:cols/2) = tmp(:,cols/2+1:cols);
        %             notop_derived(:,cols/2+1:cols) = tmp(:,1:cols/2);
        %         end
        
        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
        difference = difference./notop_derived;
        
        %% plot 1
        input = [SINSL_COSAS(:) SINSL_SINAS(:) STDEV_ELEV(:) SKY_VIEW(:)  TERRAIN_CONFIG(:) albedo_notop(:)];
        output = difference(:)*100;
        
        figure;
        subplot(2,3,1)
        scatter(input(:,1), output, 10,'k','filled', 'MarkerFaceAlpha',0.2)
        subplot(2,3,2)
        scatter(input(:,2), output, 10,'k','filled', 'MarkerFaceAlpha',0.2)
        subplot(2,3,3)
        scatter(input(:,3), output, 10,'k','filled', 'MarkerFaceAlpha',0.2)
        subplot(2,3,4)
        scatter(input(:,4), output, 10,'k','filled', 'MarkerFaceAlpha',0.2)
        subplot(2,3,5)
        scatter(input(:,5), output, 10,'k','filled', 'MarkerFaceAlpha',0.2)
        subplot(2,3,6)
        scatter(input(:,6), output, 10,'k','filled', 'MarkerFaceAlpha',0.2)
        
        tmp = corrcoef(input(:,1), output);
        Rs(1,i) = tmp(1,2);
        tmp = corrcoef(input(:,2), output);
        Rs(2,i) = tmp(1,2);
        tmp = corrcoef(input(:,3), output);
        Rs(3,i) = tmp(1,2);
        tmp = corrcoef(input(:,4), output);
        Rs(4,i) = tmp(1,2);
        tmp = corrcoef(input(:,5), output);
        Rs(5,i) = tmp(1,2);
        tmp = corrcoef(input(:,6), output);
        Rs(6,i) = tmp(1,2);
        
        
    end
end

%% plots
figure;
set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
set(gca, 'Position', [0.08 0.1 0.9 0.85])
colormap spring
b = bar(Rs,'linewidth',1)
ylabel('Correlation coefficient (R)');
h = gca;
h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
    '\sigma_h','V_d','C_T','Albedo_{PP}'};
h.TickLabelInterpreter = 'tex';
set(gca,'fontsize',15,'fontname','time new roman','linewidth',1)
colors = colormap(summer(4));
b(1).FaceColor = colors(4,:);
b(2).FaceColor = colors(3,:);
b(3).FaceColor = colors(2,:);
b(4).FaceColor = colors(1,:);

print(gcf, '-dtiff', '-r600', '../revised_figures/Figure4_Rs.png');
close all