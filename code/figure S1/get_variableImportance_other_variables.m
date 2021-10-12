
%% lat lon
topDir = 'C:\Users\haod776\OneDrive - PNNL\Documents\work\proposal_&_code\UCLA_3D_Topo_Data\UCLA_3D_Topo_Data\';
SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};

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
    
    
    
    %% surface temperature
    range = 50;
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
       
          Albedo_PP = mean_10_year_ELM_notop_FIRE_all;
        Albedo_3D = mean_10_year_ELM_top_FIRE_all;
        
        Albedo_PP = sqrt(sqrt(Albedo_PP./(5.67*1e-8)));
         Albedo_3D =sqrt(sqrt(Albedo_3D./(5.67*1e-8)));
        
        top_derived = Albedo_3D;
        notop_derived = Albedo_PP;
                
        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
       % difference = difference./notop_derived;
        
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
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.65 0.2 0.3])
        
        hold on
        a = output(:);
        b = predicts(:);
        
        R2s = calculateR2(a, b);
        plot([-range range], [-range range] , 'k-', 'linewidth', 1)
        [b1,bint,r,rint,stats] = regress(b, [ ones(size(a,1),1) a ]);
        P_values = stats(3);
        f1 = scatter( a, b,10,'k','filled');
        f1.MarkerFaceAlpha = 0.2;
        text(-range+0.05*range*2,0.86*range,['R^2=' num2str(R2s,'%4.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        %text(0.05,-0.09,['P=' num2str(P_values,'%4.4f')],'fontsize',8,'fontname','time new roman', 'color', 'b')
        text(-range+0.05*range*2,0.64*range,['y=' num2str(b1(2,1),'%0.2f') 'x+' num2str(b1(2,1),'%0.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        min_value = -range;
        max_value = range;
        
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        axis([-range range -range range])
        box on
        xlabel('(TOP-PP)/PP (%)')
        if(i==1)
            ylabel('Estimated by Random Forest');
        end
        
        set(gca,'fontsize',8,'fontname','time new roman')
        
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
        
        t = title(strcat(index, SeasonsNames{i}),'fontsize',12, 'fontweight', 'bold');
        set(t, 'horizontalAlignment', 'left');
        set(t, 'units', 'normalized');
        h1 = get(t, 'position');
        set(t, 'position', [0 h1(2) h1(3)]);
        
        
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.2 0.2 0.35])
        bar(imp, 'FaceColor', [0.5 0.5 0.5]);
        if(i==1)
            ylabel('Variable importance (%)');
        end
        %xlabel('Variable');
        h = gca;
        h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
            '\sigma_h','V_d','C_T','Albedo_{PP}'};
        h.XTickLabelRotation = 45;
        h.TickLabelInterpreter = 'tex';
        ylim([0 62])
        set(gca,'fontsize',10,'fontname','time new roman')
    end
     suptitle('surface tempetature')
    print(gcf, '-dsvg', '-r300', ['results/variable_surface_temperature_figure_S1_variable_importance_' num2str(res) 'revise.svg'])
   
    
     %% net solar radiation
    range = 50;
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
                Albedo_PP = mean_10_year_ELM_notop_FSA_all;
        Albedo_3D = mean_10_year_ELM_top_FSA_all;      
        
                top_derived = Albedo_3D;
        notop_derived = Albedo_PP;

        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
       % difference = difference./notop_derived;
        
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
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.65 0.2 0.3])
        
        hold on
        a = output(:);
        b = predicts(:);
        
        R2s = calculateR2(a, b);
        plot([-range range], [-range range] , 'k-', 'linewidth', 1)
        [b1,bint,r,rint,stats] = regress(b, [ ones(size(a,1),1) a ]);
        P_values = stats(3);
        f1 = scatter( a, b,10,'k','filled');
        f1.MarkerFaceAlpha = 0.2;
        text(-range+0.05*range*2,0.86*range,['R^2=' num2str(R2s,'%4.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        %text(0.05,-0.09,['P=' num2str(P_values,'%4.4f')],'fontsize',8,'fontname','time new roman', 'color', 'b')
        text(-range+0.05*range*2,0.64*range,['y=' num2str(b1(2,1),'%0.2f') 'x+' num2str(b1(2,1),'%0.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        min_value = -range;
        max_value = range;
        
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        axis([-range range -range range])
        box on
        xlabel('(TOP-PP)/PP (%)')
        if(i==1)
            ylabel('Estimated by Random Forest');
        end
        
        set(gca,'fontsize',8,'fontname','time new roman')
        
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
        
        t = title(strcat(index, SeasonsNames{i}),'fontsize',12, 'fontweight', 'bold');
        set(t, 'horizontalAlignment', 'left');
        set(t, 'units', 'normalized');
        h1 = get(t, 'position');
        set(t, 'position', [0 h1(2) h1(3)]);
        
        
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.2 0.2 0.35])
        bar(imp, 'FaceColor', [0.5 0.5 0.5]);
        if(i==1)
            ylabel('Variable importance (%)');
        end
        %xlabel('Variable');
        h = gca;
        h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
            '\sigma_h','V_d','C_T','Albedo_{PP}'};
        h.XTickLabelRotation = 45;
        h.TickLabelInterpreter = 'tex';
        ylim([0 62])
        set(gca,'fontsize',10,'fontname','time new roman')
    end
     suptitle('net solar radiation')
    print(gcf, '-dsvg', '-r300', ['results/variable_net_solar_radiation_figure_S1_variable_importance_' num2str(res) 'revise.svg'])
    
    
     %% snow cover fraction
    range = 50;
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
      Albedo_PP = mean_10_year_ELM_notop_FSNO_average_all*100;
        Albedo_3D = mean_10_year_ELM_top_FSNO_average_all*100;          
                        top_derived = Albedo_3D;
        notop_derived = Albedo_PP;

        
        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
       % difference = difference;%./notop_derived;
        
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
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.65 0.2 0.3])
        
        hold on
        a = output(:);
        b = predicts(:);
        
        R2s = calculateR2(a, b);
        plot([-range range], [-range range] , 'k-', 'linewidth', 1)
        [b1,bint,r,rint,stats] = regress(b, [ ones(size(a,1),1) a ]);
        P_values = stats(3);
        f1 = scatter( a, b,10,'k','filled');
        f1.MarkerFaceAlpha = 0.2;
        text(-range+0.05*range*2,0.86*range,['R^2=' num2str(R2s,'%4.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        %text(0.05,-0.09,['P=' num2str(P_values,'%4.4f')],'fontsize',8,'fontname','time new roman', 'color', 'b')
        text(-range+0.05*range*2,0.64*range,['y=' num2str(b1(2,1),'%0.2f') 'x+' num2str(b1(2,1),'%0.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        min_value = -range;
        max_value = range;
        
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        axis([-range range -range range])
        box on
        xlabel('(TOP-PP)/PP (%)')
        if(i==1)
            ylabel('Estimated by Random Forest');
        end
        
        set(gca,'fontsize',8,'fontname','time new roman')
        
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
        
        t = title(strcat(index, SeasonsNames{i}),'fontsize',12, 'fontweight', 'bold');
        set(t, 'horizontalAlignment', 'left');
        set(t, 'units', 'normalized');
        h1 = get(t, 'position');
        set(t, 'position', [0 h1(2) h1(3)]);
        
        
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.2 0.2 0.35])
        bar(imp, 'FaceColor', [0.5 0.5 0.5]);
        if(i==1)
            ylabel('Variable importance (%)');
        end
        %xlabel('Variable');
        h = gca;
        h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
            '\sigma_h','V_d','C_T','Albedo_{PP}'};
        h.XTickLabelRotation = 45;
        h.TickLabelInterpreter = 'tex';
        ylim([0 62])
        set(gca,'fontsize',10,'fontname','time new roman')
    end
     suptitle('snow cover')
    print(gcf, '-dsvg', '-r300', ['results/variable_snow_cover_figure_S1_variable_importance_' num2str(res) 'revise.svg'])
    
    
    
     %% latent heat flux
    range = 50;
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
        Albedo_PP = mean_10_year_ELM_notop_LH_all;
        Albedo_3D = mean_10_year_ELM_top_LH_all;
        top_derived = Albedo_3D;
        notop_derived = Albedo_PP;
   
        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
       % difference = difference./notop_derived;
        
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
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.65 0.2 0.3])
        
        hold on
        a = output(:);
        b = predicts(:);
        
        R2s = calculateR2(a, b);
        plot([-range range], [-range range] , 'k-', 'linewidth', 1)
        [b1,bint,r,rint,stats] = regress(b, [ ones(size(a,1),1) a ]);
        P_values = stats(3);
        f1 = scatter( a, b,10,'k','filled');
        f1.MarkerFaceAlpha = 0.2;
        text(-range+0.05*range*2,0.86*range,['R^2=' num2str(R2s,'%4.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        %text(0.05,-0.09,['P=' num2str(P_values,'%4.4f')],'fontsize',8,'fontname','time new roman', 'color', 'b')
        text(-range+0.05*range*2,0.64*range,['y=' num2str(b1(2,1),'%0.2f') 'x+' num2str(b1(2,1),'%0.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        min_value = -range;
        max_value = range;
        
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        axis([-range range -range range])
        box on
        xlabel('(TOP-PP)/PP (%)')
        if(i==1)
            ylabel('Estimated by Random Forest');
        end
        
        set(gca,'fontsize',8,'fontname','time new roman')
        
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
        
        t = title(strcat(index, SeasonsNames{i}),'fontsize',12, 'fontweight', 'bold');
        set(t, 'horizontalAlignment', 'left');
        set(t, 'units', 'normalized');
        h1 = get(t, 'position');
        set(t, 'position', [0 h1(2) h1(3)]);
        
        
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.2 0.2 0.35])
        bar(imp, 'FaceColor', [0.5 0.5 0.5]);
        if(i==1)
            ylabel('Variable importance (%)');
        end
        %xlabel('Variable');
        h = gca;
        h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
            '\sigma_h','V_d','C_T','Albedo_{PP}'};
        h.XTickLabelRotation = 45;
        h.TickLabelInterpreter = 'tex';
        ylim([0 62])
        set(gca,'fontsize',10,'fontname','latent heat flux')
    end
     suptitle('latent heat flux')
    print(gcf, '-dsvg', '-r300', ['results/variable_latent_heat_flux_figure_S1_variable_importance_' num2str(res) 'revise.svg'])
    
    
     %% sensible heat flux
    range = 50;
    figure;
    set(gcf,'unit','normalized','position',[0.1,0.1,0.8,0.6]);
    set(gca, 'Position', [0 0 1 1])
    
    for i = 1:4
        
        load(['../../data/10year_average/' scale '_' SeasonsNames{i} '_alldata.mat']);
  Albedo_PP = mean_10_year_ELM_notop_FSH_all;
        Albedo_3D = mean_10_year_ELM_top_FSH_all;
                                top_derived = Albedo_3D;
        notop_derived = Albedo_PP;

        
        difference = top_derived - notop_derived;
        albedo_notop = notop_derived;
       % difference = difference./notop_derived;
        
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
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.65 0.2 0.3])
        
        hold on
        a = output(:);
        b = predicts(:);
        
        R2s = calculateR2(a, b);
        plot([-range range], [-range range] , 'k-', 'linewidth', 1)
        [b1,bint,r,rint,stats] = regress(b, [ ones(size(a,1),1) a ]);
        P_values = stats(3);
        f1 = scatter( a, b,10,'k','filled');
        f1.MarkerFaceAlpha = 0.2;
        text(-range+0.05*range*2,0.86*range,['R^2=' num2str(R2s,'%4.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        %text(0.05,-0.09,['P=' num2str(P_values,'%4.4f')],'fontsize',8,'fontname','time new roman', 'color', 'b')
        text(-range+0.05*range*2,0.64*range,['y=' num2str(b1(2,1),'%0.2f') 'x+' num2str(b1(2,1),'%0.2f')],'fontsize',10,'fontname','time new roman', 'color', 'r')
        min_value = -range;
        max_value = range;
        
        plot([min_value max_value], [ b1(1,1) + min_value*b1(2,1) b1(1,1) + max_value*b1(2,1) ], 'r', 'linewidth', 1.5)
        axis([-range range -range range])
        box on
        xlabel('(TOP-PP)/PP (%)')
        if(i==1)
            ylabel('Estimated by Random Forest');
        end
        
        set(gca,'fontsize',8,'fontname','time new roman')
        
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
        
        t = title(strcat(index, SeasonsNames{i}),'fontsize',12, 'fontweight', 'bold');
        set(t, 'horizontalAlignment', 'left');
        set(t, 'units', 'normalized');
        h1 = get(t, 'position');
        set(t, 'position', [0 h1(2) h1(3)]);
        
        
        
        subplot('position', [0.05 + 0.93/4*(i-1) 0.2 0.2 0.35])
        bar(imp, 'FaceColor', [0.5 0.5 0.5]);
        if(i==1)
            ylabel('Variable importance (%)');
        end
        %xlabel('Variable');
        h = gca;
        h.XTickLabel = {  'sin(\alpha)\cdotcos(\beta)','sin(\alpha)\cdotsin(\beta)',...
            '\sigma_h','V_d','C_T','Albedo_{PP}'};
        h.XTickLabelRotation = 45;
        h.TickLabelInterpreter = 'tex';
        ylim([0 62])
        set(gca,'fontsize',10,'fontname','time new roman')
    end
    suptitle('sensible heat flux')
    print(gcf, '-dsvg', '-r300', ['results/variable_sensible_heat_flux_figure_S1_variable_importance_' num2str(res) 'revise.svg'])
    
    close all
end
