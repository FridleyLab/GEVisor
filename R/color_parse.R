##
# This function generates a color palette to be used with discrete_scale_manual
# in ggplot objects. It takes the name of a palette from khroma or RColorBrewer, or
# a vector of color hex and the number of categories (clusters in this case).
#

color_parse = function(color_pal=NULL, n_cats=NULL){
  # Get color palette and number of colors needed.
  # Get names of Khroma colors.
  khroma_cols = khroma::info()
  khroma_cols = khroma_cols$palette
  
  # Assume 5 categories if n_cats not provided (for kriging/quilts).
  if(is.null(n_cats)){
    n_cats = 5
  }
  
  # Test if input is a Khroma name or RColorBrewer.
  # If so, create palette.
  if(color_pal[1] %in% khroma_cols){
    p_palette = khroma::colour(color_pal[1])
    cat_cols = as.vector(p_palette(n_cats))
  }else if(color_pal[1] %in% rownames(RColorBrewer::brewer.pal.info)){
    cat_cols = RColorBrewer::brewer.pal(n_cats, color_pal[1])
  }else{ # Test if user provided a vector of colors.
    if(length(color_pal) >= n_cats){
      cat_cols = color_pal[1:n_cats]
    } else{
      stop('Provide enough colors to plot or an appropriate Khroma/RColorBrewer palette.')
    }
  }
  return(cat_cols)
}

