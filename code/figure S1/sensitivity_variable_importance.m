
%% lat lon
topDir = 'C:\Users\haod776\OneDrive - PNNL\Documents\work\proposal_&_code\UCLA_3D_Topo_Data\UCLA_3D_Topo_Data\';
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

res_vs = {0.125 0.25 0.5 180/192 180/192*2};
res_hs = {0.125 0.25 0.5 360/288 360/288*2};
col_alls = {2880, 1440, 720, 288, 144}; %% 72 26 104 40
topFilenames = {'topo_3d_0.125x0.125.nc','topo_3d_0.25x0.25.nc','topo_3d_0.5x0.5.nc','topo_3d_0.9x1.25_c150322.nc','topo_3d_1.9x2.5_c150322.nc'};
scales = {'r0125','r025', 'r05', 'f09', 'f19'};


range = 50;
figure;
set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
set(gca, 'Position', [0 0 1 1])


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
    
    
    
    
    for i = 1:1
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        top_derived = mean_10_year_ELM_top_Albedo_weighted_all;
        notop_derived = mean_10_year_ELM_notop_Albedo_weighted_all;
        
        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
        difference = difference./notop_derived;
        
        %% plot 1
        input = [SINSL_COSAS(:) SINSL_SINAS(:) STDEV_ELEV(:) SKY_VIEW(:)  TERRAIN_CONFIG(:) albedo_notop(:)];
        output = difference(:)*100;
        
        size_of_data = size(input,1);
        Num_of_predictor = 3;
        Mdl = TreeBagger(50,input,output, ...
            'Method','regression',...
            'PredictorSelection','curvature',...
            'OOBPredictorImportance','On', ...
            'MaxNumSplits',size_of_data, ...
            'NumPredictorsToSample',Num_of_predictor,'MinLeafSize',5);
        imp = Mdl.OOBPermutedPredictorDeltaError;
        imp = imp/sum(imp) * 100;
        predicts = predict(Mdl, input);
        
        
        row = floor(res/4) + 1;
        col = res - (row - 1)*3;
        
        if row == 2
            subplot('position', [0.05 + 0.93/3*(col-1) 0.17  0.3 0.35])
        else
            subplot('position', [0.05 + 0.93/3*(col-1) 0.59*(2-row)  0.3 0.35])
            
        end
        
        if(res ==1 )
            load('1.mat');
        end
        bar(imp, 'FaceColor', [0.5 0.5 0.5]);
        
        %xlabel('Variable');
        h = gca;
        if row == 2
            h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
                '\sigma_h','V_d','C_T','Albedo_{PP}'};
        else
            h.XTickLabel = [];
        end
        
        if(col==1)
            ylabel('Variable importance (%)');
        else
            h.YTickLabel = [];
        end
        
        h.XTickLabelRotation = 45;
        h.TickLabelInterpreter = 'tex';
        ylim([0 62])
        
        switch res
            case 1
                index = "(a) r0125";
            case 2
                index = "(b) r025";
            case 3
                index = "(c) r05";
            case 4
                index = "(d) f09";
            case 5
                index = "(e) f19";
        end
        
        t = title(index,'fontsize',12, 'fontweight', 'bold');
                set(t, 'horizontalAlignment', 'left');
        set(t, 'units', 'normalized');
        h1 = get(t, 'position');
        set(t, 'position', [0 h1(2) h1(3)]);
        
        set(gca,'fontsize',10,'fontname','time new roman')
    end
end
    print(gcf, '-dpng', '-r300', ['../figure_submitted/fig05.png'])


