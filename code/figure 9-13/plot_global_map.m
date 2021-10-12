function plot_global_map(lats, lons, sw_total, min_clr, max_clr, title_text, colors_single, isyticklabel, isxticklabel)
axis equal
m_proj('miller','lat',[23 41],'lon',[71 106]); % robinson Mollweide
%m_coast('color','k');
hold on

if isyticklabel && isxticklabel
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], ...
        'fontsize',6.5);
elseif isyticklabel && ~isxticklabel
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], 'xticklabels',[], ...
        'fontsize',6.5);
elseif ~isyticklabel && isxticklabel
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], 'yticklabels',[], ...
        'fontsize',6.5);
else
    m_grid('tickdir','out','linestyle','none','backcolor',[.9 .99 1], 'xticklabels',[], 'yticklabels',[], ...
        'fontsize',6.5);
end

m_pcolor(lons,lats,sw_total);
% M=m_shaperead('../../data/TP_shp/ROTW_China');
% for k=1:length(M.ncst)
%     m_line(M.ncst{k}(:,1),M.ncst{k}(:,2),'color','k','linewidth',1);
% end

%% plot contour
res_v = 0.125;
res_h = 0.125;
lon = (71+res_h/2):res_h: (106-res_h/2);
lat = (41-res_v/2):-res_v: (23 + res_v/2);
[lons2,lats2]=meshgrid(lon,lat);

load("C:\Users\haod776\OneDrive - PNNL\Documents\work\E3SM\writting\topographic effects\plot_figures\code\figure 1\dem_0125_mean_std.mat");
m_contour(lons2,lats2, mean_DEM_0125, [1500 1500], 'edgecolor',[0 0 0],'facecolor','none', 'linewidth', 1);


shading flat;
caxis([min_clr-1e-5,max_clr+1e-5])
%colormap(m_colmap('jet','step',10));
%m_text(-170,80,sub_text,'fontsize',10)
%colorbar
%colormap(colors_single);

if title_text ~= ""
    t = title(title_text,'fontsize',12, 'fontweight', 'bold');
    set(t, 'horizontalAlignment', 'left');
    set(t, 'units', 'normalized');
    h1 = get(t, 'position');
    set(t, 'position', [0 h1(2) h1(3)]);
end

set(gca, 'FontName', 'Time New Roman');

view(0,90);
hold off