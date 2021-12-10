##
#
#

plot_clusters_interactive = function(res, markers, col_pal){
  topgenes = markers %>% 
    group_by(cluster) %>% 
    # arrange(p_val_adj, .by_group = TRUE) %>% 
    slice_min(order_by = p_val_adj, n = 5, with_ties = F) %>% 
    select(cluster, gene) %>% 
    mutate(num = seq(n())) %>%
    tidyr::spread(num, gene) %>%
    tidyr::unite("all", `1`:`5`, sep = ", ")
  
  
  res = dplyr::full_join(res, topgenes, by='cluster')
  
  col_pal = color_parse(col_pal, n_cats = nrow(topgenes))
  
  p1 = ggplot2::ggplot(res) +
    ggiraph::geom_point_interactive(ggplot2::aes(x=x_pos, y=y_pos, color=cluster, tooltip = all)) +
    ggplot2::scale_color_manual(values=col_pal) +
    ggplot2::theme_classic() +
    coord_equal()
  
  #ggiraph::girafe(ggobj = p1)
  
}
