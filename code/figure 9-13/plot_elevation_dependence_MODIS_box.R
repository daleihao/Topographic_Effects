library(tidyverse)
library(R.matlab)
library(cowplot)
library(reshape2)
setwd('C:/Users/haod776/OneDrive - PNNL/Documents/work/E3SM/writting/topographic effects/plot_figures/code/figure 9-13/')

# import data
scale = 'r0125';
variables_name = c('BSA','WSA', 'SC', 'ST_d', 'ST_n','LH');
codes = c('(a) Direct albedo','(b) Diffuse albedo', '(c) Snow cover fraction', '(d) Daytime surface temperature', '(e) Nighttime surface temperature','(f) Latent heat flux');
for (i in 1:6)
{
  code = codes[i];
  name = variables_name[i];
  
  all_datas <- readMat(paste0('MODIS_', name, '.mat'));
  
  all_data <- as.data.frame(all_datas['group.data'])  
  colnames(all_data) <- c('Elevation','Winter', 'Spring', 'Summer', 'Autumn')
  #all_data <- melt(all_data, id.vars = c('Elevation'))
  all_data <- all_data %>% 
    select(Elevation, Winter) %>% 
    filter(Elevation>1)
  all_data[['Elevation']] <- factor(all_data[['Elevation']])
  all_data <- all_data %>% filter(Winter>-100)
  plot_scale_difference <- ggplot(all_data, aes(x = Winter, fill = Elevation)) + ylab('d')  +ggtitle(code) +
    #tat_boxplot(geom ='errorbar', width = 0.6, size = 0.5, show.legend = FALSE) +
    geom_density(alpha=.3) + 
    #geom_boxplot(size = 0.3, show.legend = TRUE, width = 0.6, outlier.shape = 1,outlier.size = 0.1, outlier.alpha = 0.1) + 
    theme_classic() + 
    theme(plot.title = element_text(face="bold", color="black",size=15, angle=0),
          axis.title.x=element_blank(),
          axis.text.x = element_text(color="black",size=10, angle=0),
          axis.text.y = element_text( color="black", size=10, angle=0),
          axis.title.y = element_text(face="bold", color="black",size=15),
          axis.line = element_line(size = 0.5)) +
    scale_fill_brewer(palette="Dark2", labels = c('1.5-2.5 km','2.5-3.5 km','3.5-4.5 km','>4.5 km')) +
    #lim(c(-0.2,0.2))+
    geom_hline(yintercept=0, linetype = "dashed", color = 'red')
  if(i == 1)
  {
    plot_scale_difference <- plot_scale_difference + 
      xlim(c(-0.1,0.1)) + 
      xlab(expression("|"~delta[TOP]~"|"~-~"|"~delta[PP]~"|"))
  }
  else if(i==2)
  { plot_scale_difference <- plot_scale_difference + 
    xlim(c(-0.1,0.1)) + 
    xlab(expression("|"~delta[TOP]~"|"~-~"|"~delta[PP]~"|"))}
  else if(i==3)
  { plot_scale_difference <- plot_scale_difference + 
    xlim(c(-2,2)) + 
    xlab(expression("|"~delta[TOP]~"|"~-~"|"~delta[PP]~"| (%)" ))}
  else if(i==4)
  { plot_scale_difference <- plot_scale_difference + 
    xlim(c(-1,1)) + 
    xlab(expression("|"~delta[TOP]~"|"~-~"|"~delta[PP]~"| (K)"))}
  else if(i==5)
  { plot_scale_difference <- plot_scale_difference + 
    xlim(c(-0.5,0.5)) + 
    xlab(expression("|"~delta[TOP]~"|"~-~"|"~delta[PP]~"| (K)"))}
  else
  { plot_scale_difference <- plot_scale_difference + 
    xlim(c(-1,1)) + 
    xlab(expression("|"~delta[TOP]~"|"~-~"|"~delta[PP]~"| ("~W/m^2~")"))}
  ggsave(paste0('PDF_MODIS_', name, '_',scale,".tiff"), plot = plot_scale_difference, width = 15, height = 7, units = "cm", dpi = 300, limitsize = FALSE, compression = "lzw")
}
