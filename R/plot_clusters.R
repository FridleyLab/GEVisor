##
# This function returns a scatterplot resulting from spatial coordinates and the cluster
# assignments. It also takes a vector of colors to plot (e.g., the output of color_parse)

plot_clusters = function(res, col_pal){
  ggplot2::ggplot(res) +
    ggplot2::geom_point(ggplot2::aes(x=x_pos, y=y_pos, color=cluster)) +
    ggplot2::scale_color_manual(values=col_pal) +
    ggplot2::theme_classic() +
    ggplot2::scale_y_reverse() +
    ggplot2::coord_equal()
}

plot_clusters_interactive = function(res, col_pal){
# plot_clusters = function(res, col_pal){
  ggplot2::ggplot(res, ggplot2::aes(x=x_pos, y=y_pos, color=cluster)) +
    ggiraph::geom_point_interactive(aes(tooltip = cluster), size=3) +
    ggplot2::scale_color_manual(values=col_pal) +
    ggplot2::theme_classic() + 
    ggplot2::scale_y_reverse() +
    ggplot2::coord_equal()
}

