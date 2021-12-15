##
# @param decon, the result from spatialdecon_wrap
#

plot_cell_abund = function(decon, df_spatial, 
                           #celltype='endothelial.cells', 
                           col_pal){
  decon_df = as.data.frame(t(decon)) %>%
    tibble::rownames_to_column(var='roi')
  
  cellnames = colnames(decon_df[, -1])
  
  df_spatial_temp = df_spatial[, c("SegmentDisplayName", "ROICoordinateX", "ROICoordinateY")]
  
  df_plot = dplyr::full_join(df_spatial_temp, decon_df, by=c('SegmentDisplayName'='roi'))
  
 # col_pal = col_pal[names(col_pal) %in% cellnames]
  
  d_plot = ggplot2::ggplot(data=df_plot) +
    #ggplot2::ggplot(df_plot) +
    scatterpie::geom_scatterpie(data=df_plot, ggplot2::aes(x=ROICoordinateX, y=ROICoordinateY), 
                                cols=cellnames, pie_scale = 1.5, color=NA) +
    #ggplot2::geom_point(ggplot2::aes(x=ROICoordinateX, y=ROICoordinateY, color=get(celltype)), size = 3) +
    #ggplot2::scale_color_gradientn(colors=col_pal) +
    ggplot2::scale_y_reverse() +
    ggplot2::ylab('y_pos') +
    ggplot2::xlab('x_pos') +
    #scale_fill_manual(values=col_pal) +
    #ggplot2::guides(color=ggplot2::guide_legend(title=paste0(celltype, "\nScore"))) +
    ggplot2::coord_equal() +
    ggplot2::theme_classic()
  
  d_plot
}





