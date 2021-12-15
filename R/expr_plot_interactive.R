##
# Plots log-normal expression of counts
#

expr_plot_interactive = function(df, df_spatial, gene, col_pal){

  # Calculate (spot) library sizes. Then, add 1 to each library size.
  df[is.na(df)] = 0
  libsizes = colSums(df[, -1], na.rm=T)
  
  # Filterv out zero count spots
  roi_mask = libsizes == 0
  libsizes = libsizes[!roi_mask]
  df = df[, 1] %>%
    dplyr::bind_cols(., df[, c(F, !roi_mask)])
  
  # Divide each count value by their respective column (spot) normalization factor.
  df1 = sweep(df[, -1], 2, libsizes, '/')
  # Then multiply by scaling factor
  df1 = df1 * 10000
  # Apply log transformation to count data.
  df1 = log1p(df1)
  
  df = dplyr::bind_cols(df[, 1], df1)
  
  expr = as.data.frame(t(df[grep(paste0('^', gene, '$'), df$TargetName), -1]))
  colnames(expr) = 'expr'
  expr = tibble::rownames_to_column(.data=expr, var='roi')
  expr = dplyr::full_join(df_spatial, expr, by=c('SegmentDisplayName'='roi'))
  
  p1=ggplot2::ggplot(data=expr) +
    #ggplot2::annotation_custom(img_obj, xmin=0, xmax=1) +
    ggiraph::geom_point_interactive(ggplot2::aes(x=ROICoordinateX, y=ROICoordinateY, color=expr, tooltip = expr), size=3) +
    ggplot2::scale_color_gradientn(colors=col_pal) +
    ggtitle(paste0('log_expr ', gene)) +
    ggplot2::theme_classic() + 
    ggplot2::scale_y_reverse() +
    coord_equal()
  
  p1
}

