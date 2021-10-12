clc;
clear all;
close all;

scale = 'f19';

SeasonsNames = {'Winter', 'Spring', 'Summer', 'Autumn'};
for season_i = 1:4
    %% initialize
    mean_10_year_ELM_top_BSA_all = [];
    mean_10_year_ELM_notop_BSA_all = [];
    mean_10_year_ELM_top_WSA_all = [];
    mean_10_year_ELM_notop_WSA_all = [];
    mean_10_year_ELM_top_Albedo_weighted_all = [];
    mean_10_year_ELM_notop_Albedo_weighted_all = [];
    mean_10_year_ELM_top_SWE_average_all = [];
    mean_10_year_ELM_notop_SWE_average_all = [];
    mean_10_year_ELM_top_Albedo_all = [];
    mean_10_year_ELM_notop_Albedo_all = [];
    mean_10_year_ELM_top_FSH_all = [];
    mean_10_year_ELM_notop_FSH_all = [];
    mean_10_year_ELM_top_LH_all = [];
    mean_10_year_ELM_notop_LH_all = [];
    mean_10_year_ELM_notop_TV_all = [];
    mean_10_year_ELM_top_TV_all = [];
    mean_10_year_ELM_notop_SNOWDP_average_all = [];
    mean_10_year_ELM_top_SNOWDP_average_all = [];
    mean_10_year_ELM_notop_netradiation_all = [];
    mean_10_year_ELM_top_netradiation_all = [];
    mean_10_year_ELM_notop_FSNO_average_all = [];
    mean_10_year_ELM_top_FSNO_average_all = [];
    mean_10_year_ELM_notop_TSOI_average_all = [];
    mean_10_year_ELM_top_TSOI_average_all = [];
    mean_10_year_ELM_notop_QSNOMELT_all = [];
    mean_10_year_ELM_top_QSNOMELT_all = [];
    mean_10_year_MODIS_BSA_all = [];
    mean_10_year_MODIS_WSA_all = [];
    mean_10_year_ELM_notop_TSA_all = [];
    mean_10_year_ELM_top_TSA_all = [];
    
    mean_10_year_MODIS_SnowCover_all = [];
    mean_10_year_MODIS_daytimeST_all = [];
    mean_10_year_MODIS_nighttimeST_all = [];
    mean_10_year_MODIS_LatentHeatFlux_all = [];
    mean_10_year_ELM_notop_TG_all = [];
    mean_10_year_ELM_top_TG_all = [];
    mean_10_year_ELM_notop_FSA_all = [];
    mean_10_year_ELM_top_FSA_all = [];
    mean_10_year_ELM_notop_FSDS_all = [];
    mean_10_year_ELM_top_FSDS_all = [];
    mean_10_year_ELM_notop_FSR_all = [];
    mean_10_year_ELM_top_FSR_all = [];
    mean_10_year_ELM_notop_FIRA_all = [];
    mean_10_year_ELM_top_FIRA_all = [];
    mean_10_year_ELM_notop_FIRE_all = [];
    mean_10_year_ELM_top_FIRE_all = [];
    mean_10_year_ELM_notop_FLDS_all = [];
    mean_10_year_ELM_top_FLDS_all = [];
    mean_10_year_ELM_notop_FGR_all = [];
    mean_10_year_ELM_top_FGR_all = [];
    mean_10_year_ELM_notop_daytimeST_all = [];
    mean_10_year_ELM_top_daytimeST_all = [];
    mean_10_year_ELM_notop_nighttimeST_all = [];
    mean_10_year_ELM_top_nighttimeST_all = [];
    
    for year_i = 2001:2010
        load(['results/' scale '/' num2str(year_i) '_' SeasonsNames{season_i} '_alldata.mat']);
        
        if year_i == 2001
            mean_10_year_ELM_top_BSA_all = mean_ELM_top_BSA_all;
            mean_10_year_ELM_notop_BSA_all = mean_ELM_notop_BSA_all;
            mean_10_year_ELM_top_WSA_all = mean_ELM_top_WSA_all;
            mean_10_year_ELM_notop_WSA_all = mean_ELM_notop_WSA_all;
            mean_10_year_ELM_top_Albedo_weighted_all = mean_ELM_top_Albedo_weighted_all;
            mean_10_year_ELM_notop_Albedo_weighted_all = mean_ELM_notop_Albedo_weighted_all;
            mean_10_year_ELM_top_SWE_average_all = mean_ELM_top_SWE_average_all;
            mean_10_year_ELM_notop_SWE_average_all = mean_ELM_notop_SWE_average_all;
            mean_10_year_ELM_top_Albedo_all = mean_ELM_top_Albedo_all;
            mean_10_year_ELM_notop_Albedo_all = mean_ELM_notop_Albedo_all;
            mean_10_year_ELM_top_FSH_all = mean_ELM_top_FSH_all;
            mean_10_year_ELM_notop_FSH_all = mean_ELM_notop_FSH_all;
            mean_10_year_ELM_top_LH_all = mean_ELM_top_LH_all;
            mean_10_year_ELM_notop_LH_all = mean_ELM_notop_LH_all;
            mean_10_year_ELM_notop_TV_all = mean_ELM_notop_TV_all;
            mean_10_year_ELM_top_TV_all = mean_ELM_top_TV_all;
            mean_10_year_ELM_notop_SNOWDP_average_all = mean_ELM_notop_SNOWDP_average_all;
            mean_10_year_ELM_top_SNOWDP_average_all = mean_ELM_top_SNOWDP_average_all;
            mean_10_year_ELM_notop_netradiation_all = mean_ELM_notop_netradiation_all;
            mean_10_year_ELM_top_netradiation_all = mean_ELM_top_netradiation_all;
            mean_10_year_ELM_notop_FSNO_average_all = mean_ELM_notop_FSNO_average_all;
            mean_10_year_ELM_top_FSNO_average_all = mean_ELM_top_FSNO_average_all;
            mean_10_year_ELM_notop_TSOI_average_all = mean_ELM_notop_TSOI_average_all;
            mean_10_year_ELM_top_TSOI_average_all = mean_ELM_top_TSOI_average_all;
            mean_10_year_ELM_notop_QSNOMELT_all = mean_ELM_notop_QSNOMELT_all;
            mean_10_year_ELM_top_QSNOMELT_all = mean_ELM_top_QSNOMELT_all;
            mean_10_year_MODIS_BSA_all = mean_MODIS_BSA_all;
            mean_10_year_MODIS_WSA_all = mean_MODIS_WSA_all;
            mean_10_year_ELM_notop_TSA_all = mean_ELM_notop_TSA_all;
            mean_10_year_ELM_top_TSA_all = mean_ELM_top_TSA_all;
            
            mean_10_year_MODIS_SnowCover_all = mean_MODIS_SnowCover_all;
            mean_10_year_MODIS_daytimeST_all = mean_MODIS_daytimeST_all;
            mean_10_year_MODIS_nighttimeST_all = mean_MODIS_nighttimeST_all;
            mean_10_year_MODIS_LatentHeatFlux_all = mean_MODIS_LatentHeatFlux_all;
            mean_10_year_ELM_notop_TG_all = mean_ELM_notop_TG_all;
            mean_10_year_ELM_top_TG_all = mean_ELM_top_TG_all;
            mean_10_year_ELM_notop_FSA_all = mean_ELM_notop_FSA_all;
            mean_10_year_ELM_top_FSA_all = mean_ELM_top_FSA_all;
            mean_10_year_ELM_notop_FSDS_all = mean_ELM_notop_FSDS_all;
            mean_10_year_ELM_top_FSDS_all = mean_ELM_top_FSDS_all;
            mean_10_year_ELM_notop_FSR_all = mean_ELM_notop_FSR_all;
            mean_10_year_ELM_top_FSR_all = mean_ELM_top_FSR_all;
            mean_10_year_ELM_notop_FIRA_all = mean_ELM_notop_FIRA_all;
            mean_10_year_ELM_top_FIRA_all = mean_ELM_top_FIRA_all;
            mean_10_year_ELM_notop_FIRE_all = mean_ELM_notop_FIRE_all;
            mean_10_year_ELM_top_FIRE_all = mean_ELM_top_FIRE_all;
            mean_10_year_ELM_notop_FLDS_all = mean_ELM_notop_FLDS_all;
            mean_10_year_ELM_top_FLDS_all = mean_ELM_top_FLDS_all;
            mean_10_year_ELM_notop_FGR_all = mean_ELM_notop_FGR_all;
            mean_10_year_ELM_top_FGR_all = mean_ELM_top_FGR_all;
            mean_10_year_ELM_notop_daytimeST_all = mean_ELM_notop_daytimeST_all;
            mean_10_year_ELM_top_daytimeST_all = mean_ELM_top_daytimeST_all;
            mean_10_year_ELM_notop_nighttimeST_all = mean_ELM_notop_nighttimeST_all;
            mean_10_year_ELM_top_nighttimeST_all = mean_ELM_top_nighttimeST_all;
            
        else
            
            
            mean_10_year_ELM_top_BSA_all = mean_10_year_ELM_top_BSA_all + mean_ELM_top_BSA_all;
            mean_10_year_ELM_notop_BSA_all = mean_10_year_ELM_notop_BSA_all + mean_ELM_notop_BSA_all;
            mean_10_year_ELM_top_WSA_all = mean_10_year_ELM_top_WSA_all + mean_ELM_top_WSA_all;
            mean_10_year_ELM_notop_WSA_all = mean_10_year_ELM_notop_WSA_all + mean_ELM_notop_WSA_all;
            mean_10_year_ELM_top_Albedo_weighted_all = mean_10_year_ELM_top_Albedo_weighted_all + mean_ELM_top_Albedo_weighted_all;
            mean_10_year_ELM_notop_Albedo_weighted_all = mean_10_year_ELM_notop_Albedo_weighted_all + mean_ELM_notop_Albedo_weighted_all;
            mean_10_year_ELM_top_SWE_average_all = mean_10_year_ELM_top_SWE_average_all + mean_ELM_top_SWE_average_all;
            mean_10_year_ELM_notop_SWE_average_all = mean_10_year_ELM_notop_SWE_average_all + mean_ELM_notop_SWE_average_all;
            mean_10_year_ELM_top_Albedo_all = mean_10_year_ELM_top_Albedo_all + mean_ELM_top_Albedo_all;
            mean_10_year_ELM_notop_Albedo_all = mean_10_year_ELM_notop_Albedo_all + mean_ELM_notop_Albedo_all;
            mean_10_year_ELM_top_FSH_all = mean_10_year_ELM_top_FSH_all + mean_ELM_top_FSH_all;
            mean_10_year_ELM_notop_FSH_all = mean_10_year_ELM_notop_FSH_all + mean_ELM_notop_FSH_all;
            mean_10_year_ELM_top_LH_all = mean_10_year_ELM_top_LH_all + mean_ELM_top_LH_all;
            mean_10_year_ELM_notop_LH_all = mean_10_year_ELM_notop_LH_all + mean_ELM_notop_LH_all;
            mean_10_year_ELM_notop_TV_all = mean_10_year_ELM_notop_TV_all + mean_ELM_notop_TV_all;
            mean_10_year_ELM_top_TV_all = mean_10_year_ELM_top_TV_all + mean_ELM_top_TV_all;
            
            mean_10_year_ELM_notop_SNOWDP_average_all = mean_10_year_ELM_notop_SNOWDP_average_all + mean_ELM_notop_SNOWDP_average_all;
            mean_10_year_ELM_top_SNOWDP_average_all = mean_10_year_ELM_top_SNOWDP_average_all + mean_ELM_top_SNOWDP_average_all;
            mean_10_year_ELM_notop_netradiation_all = mean_10_year_ELM_notop_netradiation_all + mean_ELM_notop_netradiation_all;
            mean_10_year_ELM_top_netradiation_all = mean_10_year_ELM_top_netradiation_all + mean_ELM_top_netradiation_all;
            mean_10_year_ELM_notop_FSNO_average_all = mean_10_year_ELM_notop_FSNO_average_all + mean_ELM_notop_FSNO_average_all;
            mean_10_year_ELM_top_FSNO_average_all = mean_10_year_ELM_top_FSNO_average_all + mean_ELM_top_FSNO_average_all;
            mean_10_year_ELM_notop_TSOI_average_all = mean_10_year_ELM_notop_TSOI_average_all + mean_ELM_notop_TSOI_average_all;
            mean_10_year_ELM_top_TSOI_average_all = mean_10_year_ELM_top_TSOI_average_all + mean_ELM_top_TSOI_average_all;
            mean_10_year_ELM_notop_QSNOMELT_all = mean_10_year_ELM_notop_QSNOMELT_all + mean_ELM_notop_QSNOMELT_all;
            mean_10_year_ELM_top_QSNOMELT_all = mean_10_year_ELM_top_QSNOMELT_all + mean_ELM_top_QSNOMELT_all;
            mean_10_year_MODIS_BSA_all = mean_10_year_MODIS_BSA_all + mean_MODIS_BSA_all;
            mean_10_year_MODIS_WSA_all = mean_10_year_MODIS_WSA_all + mean_MODIS_WSA_all;
            mean_10_year_ELM_notop_TSA_all = mean_10_year_ELM_notop_TSA_all + mean_ELM_notop_TSA_all;
            mean_10_year_ELM_top_TSA_all = mean_10_year_ELM_top_TSA_all + mean_ELM_top_TSA_all;
            
            mean_10_year_MODIS_SnowCover_all = mean_10_year_MODIS_SnowCover_all + mean_MODIS_SnowCover_all;
            mean_10_year_MODIS_daytimeST_all = mean_10_year_MODIS_daytimeST_all + mean_MODIS_daytimeST_all;
            mean_10_year_MODIS_nighttimeST_all = mean_10_year_MODIS_nighttimeST_all + mean_MODIS_nighttimeST_all;
            mean_10_year_MODIS_LatentHeatFlux_all = mean_10_year_MODIS_LatentHeatFlux_all + mean_MODIS_LatentHeatFlux_all;
            mean_10_year_ELM_notop_TG_all = mean_10_year_ELM_notop_TG_all + mean_ELM_notop_TG_all;
            mean_10_year_ELM_top_TG_all = mean_10_year_ELM_top_TG_all + mean_ELM_top_TG_all;
            mean_10_year_ELM_notop_FSA_all = mean_10_year_ELM_notop_FSA_all + mean_ELM_notop_FSA_all;
            mean_10_year_ELM_top_FSA_all = mean_10_year_ELM_top_FSA_all + mean_ELM_top_FSA_all;
            mean_10_year_ELM_notop_FSDS_all = mean_10_year_ELM_notop_FSDS_all + mean_ELM_notop_FSDS_all;
            mean_10_year_ELM_top_FSDS_all = mean_10_year_ELM_top_FSDS_all + mean_ELM_top_FSDS_all;
            mean_10_year_ELM_notop_FSR_all = mean_10_year_ELM_notop_FSR_all + mean_ELM_notop_FSR_all;
            mean_10_year_ELM_top_FSR_all = mean_10_year_ELM_top_FSR_all + mean_ELM_top_FSR_all;
            mean_10_year_ELM_notop_FIRA_all = mean_10_year_ELM_notop_FIRA_all + mean_ELM_notop_FIRA_all;
            mean_10_year_ELM_top_FIRA_all = mean_10_year_ELM_top_FIRA_all + mean_ELM_top_FIRA_all;
            mean_10_year_ELM_notop_FIRE_all = mean_10_year_ELM_notop_FIRE_all + mean_ELM_notop_FIRE_all;
            mean_10_year_ELM_top_FIRE_all = mean_10_year_ELM_top_FIRE_all + mean_ELM_top_FIRE_all;
            mean_10_year_ELM_notop_FLDS_all = mean_10_year_ELM_notop_FLDS_all + mean_ELM_notop_FLDS_all;
            mean_10_year_ELM_top_FLDS_all = mean_10_year_ELM_top_FLDS_all + mean_ELM_top_FLDS_all;
            mean_10_year_ELM_notop_FGR_all = mean_10_year_ELM_notop_FGR_all + mean_ELM_notop_FGR_all;
            mean_10_year_ELM_top_FGR_all = mean_10_year_ELM_top_FGR_all + mean_ELM_top_FGR_all;
            mean_10_year_ELM_notop_daytimeST_all = mean_10_year_ELM_notop_daytimeST_all + mean_ELM_notop_daytimeST_all;
            mean_10_year_ELM_top_daytimeST_all = mean_10_year_ELM_top_daytimeST_all + mean_ELM_top_daytimeST_all;
            mean_10_year_ELM_notop_nighttimeST_all = mean_10_year_ELM_notop_nighttimeST_all + mean_ELM_notop_nighttimeST_all;
            mean_10_year_ELM_top_nighttimeST_all = mean_10_year_ELM_top_nighttimeST_all + mean_ELM_top_nighttimeST_all;
        end
    end
    
    %% average
    mean_10_year_ELM_top_BSA_all = mean_10_year_ELM_top_BSA_all/10;
    mean_10_year_ELM_notop_BSA_all = mean_10_year_ELM_notop_BSA_all/10;
    mean_10_year_ELM_top_WSA_all = mean_10_year_ELM_top_WSA_all/10;
    mean_10_year_ELM_notop_WSA_all = mean_10_year_ELM_notop_WSA_all/10;
    mean_10_year_ELM_top_Albedo_weighted_all = mean_10_year_ELM_top_Albedo_weighted_all/10;
    mean_10_year_ELM_notop_Albedo_weighted_all = mean_10_year_ELM_notop_Albedo_weighted_all/10;
    mean_10_year_ELM_top_SWE_average_all = mean_10_year_ELM_top_SWE_average_all/10;
    mean_10_year_ELM_notop_SWE_average_all = mean_10_year_ELM_notop_SWE_average_all/10;
    mean_10_year_ELM_top_Albedo_all = mean_10_year_ELM_top_Albedo_all/10;
    mean_10_year_ELM_notop_Albedo_all = mean_10_year_ELM_notop_Albedo_all/10;
    mean_10_year_ELM_top_FSH_all = mean_10_year_ELM_top_FSH_all/10;
    mean_10_year_ELM_notop_FSH_all = mean_10_year_ELM_notop_FSH_all/10;
    mean_10_year_ELM_top_LH_all = mean_10_year_ELM_top_LH_all/10;
    mean_10_year_ELM_notop_LH_all = mean_10_year_ELM_notop_LH_all/10;
    mean_10_year_ELM_notop_TV_all = mean_10_year_ELM_notop_TV_all/10;
    mean_10_year_ELM_top_TV_all = mean_10_year_ELM_top_TV_all/10;
    mean_10_year_ELM_notop_SNOWDP_average_all = mean_10_year_ELM_notop_SNOWDP_average_all/10;
    mean_10_year_ELM_top_SNOWDP_average_all = mean_10_year_ELM_top_SNOWDP_average_all/10;
    mean_10_year_ELM_notop_netradiation_all = mean_10_year_ELM_notop_netradiation_all/10;
    mean_10_year_ELM_top_netradiation_all = mean_10_year_ELM_top_netradiation_all/10;
    mean_10_year_ELM_notop_FSNO_average_all = mean_10_year_ELM_notop_FSNO_average_all/10;
    mean_10_year_ELM_top_FSNO_average_all = mean_10_year_ELM_top_FSNO_average_all/10;
    mean_10_year_ELM_notop_TSOI_average_all = mean_10_year_ELM_notop_TSOI_average_all/10;
    mean_10_year_ELM_top_TSOI_average_all = mean_10_year_ELM_top_TSOI_average_all/10;
    mean_10_year_ELM_notop_QSNOMELT_all = mean_10_year_ELM_notop_QSNOMELT_all/10;
    mean_10_year_ELM_top_QSNOMELT_all = mean_10_year_ELM_top_QSNOMELT_all/10;
    mean_10_year_MODIS_BSA_all = mean_10_year_MODIS_BSA_all/10;
    mean_10_year_MODIS_WSA_all = mean_10_year_MODIS_WSA_all/10;
    mean_10_year_ELM_notop_TSA_all = mean_10_year_ELM_notop_TSA_all/10;
    mean_10_year_ELM_top_TSA_all = mean_10_year_ELM_top_TSA_all/10;
    
    mean_10_year_MODIS_SnowCover_all = mean_10_year_MODIS_SnowCover_all/10;
    mean_10_year_MODIS_daytimeST_all = mean_10_year_MODIS_daytimeST_all/10;
    mean_10_year_MODIS_nighttimeST_all = mean_10_year_MODIS_nighttimeST_all/10;
    mean_10_year_MODIS_LatentHeatFlux_all = mean_10_year_MODIS_LatentHeatFlux_all/10;
    mean_10_year_ELM_notop_TG_all = mean_10_year_ELM_notop_TG_all/10;
    mean_10_year_ELM_top_TG_all = mean_10_year_ELM_top_TG_all/10;
    mean_10_year_ELM_notop_FSA_all = mean_10_year_ELM_notop_FSA_all/10;
    mean_10_year_ELM_top_FSA_all = mean_10_year_ELM_top_FSA_all/10;
    mean_10_year_ELM_notop_FSDS_all = mean_10_year_ELM_notop_FSDS_all/10;
    mean_10_year_ELM_top_FSDS_all = mean_10_year_ELM_top_FSDS_all/10;
    mean_10_year_ELM_notop_FSR_all = mean_10_year_ELM_notop_FSR_all/10;
    mean_10_year_ELM_top_FSR_all = mean_10_year_ELM_top_FSR_all/10;
    mean_10_year_ELM_notop_FIRA_all = mean_10_year_ELM_notop_FIRA_all/10;
    mean_10_year_ELM_top_FIRA_all = mean_10_year_ELM_top_FIRA_all/10;
    mean_10_year_ELM_notop_FIRE_all = mean_10_year_ELM_notop_FIRE_all/10;
    mean_10_year_ELM_top_FIRE_all = mean_10_year_ELM_top_FIRE_all/10;
    mean_10_year_ELM_notop_FLDS_all = mean_10_year_ELM_notop_FLDS_all/10;
    mean_10_year_ELM_top_FLDS_all = mean_10_year_ELM_top_FLDS_all/10;
    mean_10_year_ELM_notop_FGR_all = mean_10_year_ELM_notop_FGR_all/10;
    mean_10_year_ELM_top_FGR_all = mean_10_year_ELM_top_FGR_all/10;
    mean_10_year_ELM_notop_daytimeST_all = mean_10_year_ELM_notop_daytimeST_all/10;
    mean_10_year_ELM_top_daytimeST_all = mean_10_year_ELM_top_daytimeST_all/10;
    mean_10_year_ELM_notop_nighttimeST_all = mean_10_year_ELM_notop_nighttimeST_all/10;
    mean_10_year_ELM_top_nighttimeST_all = mean_10_year_ELM_top_nighttimeST_all/10;
    
    
    %% save
    save(['results/' scale '_' SeasonsNames{season_i} '_alldata.mat'],'mean_10_year_ELM_top_BSA_all', 'mean_10_year_ELM_notop_BSA_all',...
        'mean_10_year_ELM_top_WSA_all', 'mean_10_year_ELM_notop_WSA_all',...
        'mean_10_year_ELM_top_Albedo_weighted_all' , 'mean_10_year_ELM_notop_Albedo_weighted_all', ...
        'mean_10_year_ELM_top_SWE_average_all' , 'mean_10_year_ELM_notop_SWE_average_all',...
        'mean_10_year_ELM_top_Albedo_all' , 'mean_10_year_ELM_notop_Albedo_all', ...
        'mean_10_year_ELM_top_FSH_all', 'mean_10_year_ELM_notop_FSH_all',...
        'mean_10_year_ELM_top_LH_all', 'mean_10_year_ELM_notop_LH_all',...
        'mean_10_year_ELM_notop_TV_all', 'mean_10_year_ELM_top_TV_all',...
        'mean_10_year_ELM_notop_SNOWDP_average_all', 'mean_10_year_ELM_top_SNOWDP_average_all',...
        'mean_10_year_ELM_notop_netradiation_all', 'mean_10_year_ELM_top_netradiation_all',...
        'mean_10_year_ELM_notop_FSNO_average_all', 'mean_10_year_ELM_top_FSNO_average_all',...
        'mean_10_year_ELM_notop_TSOI_average_all', 'mean_10_year_ELM_top_TSOI_average_all',...
        'mean_10_year_ELM_notop_QSNOMELT_all', 'mean_10_year_ELM_top_QSNOMELT_all',...
        'mean_10_year_MODIS_BSA_all','mean_10_year_MODIS_WSA_all',...
        'mean_10_year_ELM_notop_TSA_all','mean_10_year_ELM_top_TSA_all',...
        'landmasks',...
        'mean_10_year_MODIS_SnowCover_all',...
        'mean_10_year_MODIS_daytimeST_all', 'mean_10_year_MODIS_nighttimeST_all',...
        'mean_10_year_MODIS_LatentHeatFlux_all',...
        'mean_10_year_ELM_notop_TG_all','mean_10_year_ELM_top_TG_all',...
        'mean_10_year_ELM_notop_FSA_all','mean_10_year_ELM_top_FSA_all',...
        'mean_10_year_ELM_notop_FSDS_all','mean_10_year_ELM_top_FSDS_all',...
        'mean_10_year_ELM_notop_FSR_all','mean_10_year_ELM_top_FSR_all',...
        'mean_10_year_ELM_notop_FIRA_all','mean_10_year_ELM_top_FIRA_all',...
        'mean_10_year_ELM_notop_FIRE_all','mean_10_year_ELM_top_FIRE_all',...
        'mean_10_year_ELM_notop_FLDS_all','mean_10_year_ELM_top_FLDS_all',...
        'mean_10_year_ELM_notop_FGR_all','mean_10_year_ELM_top_FGR_all',...
        'mean_10_year_ELM_notop_daytimeST_all','mean_10_year_ELM_top_daytimeST_all',...
        'mean_10_year_ELM_notop_nighttimeST_all','mean_10_year_ELM_top_nighttimeST_all');
end