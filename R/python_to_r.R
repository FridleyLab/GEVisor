sandhya_data = function(df, df_spatial){
  
  ######################################################################################
  #load packages
  #reticulate::py_install(c("numpy"))
  #asssign gene names and rois, and count matrix values (not names from genes)
  np = import("numpy")
  pd = import("numpy")
  scipy.integrate = import("scipy.integrate")
  math = import("math")
  plt = import("matplotlib.pyplot")
  sns = import("seaborn")
  time = import("time")
  mp = import("multiprocessing")
  os = import("os")
  sc = import("scanpy")
  anndata = import("anndata")
  
  #python
  #from pack import mod
  #mod.func()
  #r
  # pack <- import("pack")
  # pack$mod$func()
  animation = import("matplotlib")$animation 
  rc = import("matplotlib")$rc 
  #from matplotlib import animation, rc
  HTML = import("IPython.display")$HTML 
  #from IPython.display import HTML
  zscore = import("scipy.stats")$zscore 
  #from scipy.stats import zscore
  TSNE = import ("sklearn.manifold")$TSNE
  #from sklearn.manifold import TSNE
  BayesianGaussianMixture = import("sklearn.mixture")$BayesianGaussianMixture 
  #from sklearn.mixture import BayesianGaussianMixture
  distance = import("scipy.spatial")$distance
  #from scipy.spatial import distance
  euclidean_distances = import("sklearn.metrics.pairwise")$euclidean_distances
  #from sklearn.metrics.pairwise import euclidean_distances
  
  #sc$settings$verbosity = "3"             # verbosity: errors (0), warnings (1), info (2), hints (3)
  sc$settings$set_figure_params(dpi=100)
  
  colours_30 = r_to_py(c("firebrick","gold","royalblue","green","dimgray","orchid","darkviolet",
                         "red", "orange", "limegreen", "blue", "purple", "seagreen","gold","darkolivegreen",
                         "lightpink","thistle","mistyrose","saddlebrown","slategrey","powderblue",
                         "palevioletred","mediumvioletred","yellowgreen","lemonchiffon","chocolate",
                         "lightsalmon","lightcyan","lightblue", "darkorange","magenta","sienna","midnightblue","fuchsia","violet","tomato","aqua",
                         "darkslategray","coral","lightcoral","sandybrown","indianred","olivedrab","darkgreen","blueviolet","forestgreen","darkred",
                         "dimgray","teal","cadetblue"), convert = T)
  
  roi_names = colnames(df)[-1] #roi_lymph
  roi_genes = df$TargetName #genes_lymph
  
  roi_data = df[,-1] #lymph_data
  
  num_roi = length(roi_names)
  roi_x_y = df_spatial %>% 
    select(SegmentDisplayName, ROICoordinateX, ROICoordinateY, !!colnames(df_spatial)[ncol(df_spatial)]) #roi_x_y
  rearran = roi_data %>%
    select(!!roi_x_y$SegmentDisplayName) #roi_type
  
  #spatial matrix
  lymph_data_spat = np$copy(roi_data)
  roi_x_y2 = np$array(roi_x_y[,2:3])
  ss= euclidean_distances(roi_x_y2, roi_x_y2)
  dist_plot = image(max(ss)-ss, useRaster=T, axes = T)
  
  return(dist_plot)
}

sandhya_data2 = function(df, df_spatial){
  
  ######################################################################################
  #load packages
  #reticulate::py_install(c("numpy"))
  #asssign gene names and rois, and count matrix values (not names from genes)
  np = import("numpy")
  pd = import("numpy")
  scipy.integrate = import("scipy.integrate")
  math = import("math")
  plt = import("matplotlib.pyplot")
  sns = import("seaborn")
  time = import("time")
  mp = import("multiprocessing")
  os = import("os")
  sc = import("scanpy")
  anndata = import("anndata")
  
  #python
  #from pack import mod
  #mod.func()
  #r
  # pack <- import("pack")
  # pack$mod$func()
  animation = import("matplotlib")$animation 
  rc = import("matplotlib")$rc 
  #from matplotlib import animation, rc
  HTML = import("IPython.display")$HTML 
  #from IPython.display import HTML
  zscore = import("scipy.stats")$zscore 
  #from scipy.stats import zscore
  TSNE = import ("sklearn.manifold")$TSNE
  #from sklearn.manifold import TSNE
  BayesianGaussianMixture = import("sklearn.mixture")$BayesianGaussianMixture 
  #from sklearn.mixture import BayesianGaussianMixture
  distance = import("scipy.spatial")$distance
  #from scipy.spatial import distance
  euclidean_distances = import("sklearn.metrics.pairwise")$euclidean_distances
  #from sklearn.metrics.pairwise import euclidean_distances
  
  #sc$settings$verbosity = "3"             # verbosity: errors (0), warnings (1), info (2), hints (3)
  sc$settings$set_figure_params(dpi=100)
  
  colours_30 = r_to_py(c("firebrick","gold","royalblue","green","dimgray","orchid","darkviolet",
                         "red", "orange", "limegreen", "blue", "purple", "seagreen","gold","darkolivegreen",
                         "lightpink","thistle","mistyrose","saddlebrown","slategrey","powderblue",
                         "palevioletred","mediumvioletred","yellowgreen","lemonchiffon","chocolate",
                         "lightsalmon","lightcyan","lightblue", "darkorange","magenta","sienna","midnightblue","fuchsia","violet","tomato","aqua",
                         "darkslategray","coral","lightcoral","sandybrown","indianred","olivedrab","darkgreen","blueviolet","forestgreen","darkred",
                         "dimgray","teal","cadetblue"), convert = T)
  
  roi_names = colnames(df)[-1] #roi_lymph
  roi_genes = df$TargetName #genes_lymph
  
  roi_data = df[,-1] #lymph_data
  
  num_roi = length(roi_names)
  roi_x_y = df_spatial %>% 
    select(SegmentDisplayName, ROICoordinateX, ROICoordinateY, !!colnames(df_spatial)[ncol(df_spatial)]) #roi_x_y
  rearran = roi_data %>%
    select(!!roi_x_y$SegmentDisplayName) #roi_type
  
  #spatial matrix
  lymph_data_spat = np$copy(roi_data)
  roi_x_y2 = np$array(roi_x_y[,2:3])
  ss= euclidean_distances(roi_x_y2, roi_x_y2) %>% data.frame(check.names=F)
  
  names(ss) = roi_x_y$SegmentDisplayName
  test = lapply(ss, function(x){
    names(x) = roi_x_y$SegmentDisplayName
    x[which(x<10000)]
  })
  
  means_rois = sapply(test, function(x){
    roi_data %>% select(!!names(x)) %>%
      rowMeans()
  })
  row.names(means_rois) = roi_genes
  t_means = t(means_rois)
  
  #find out how to get gene names fo rthe plotting
  adata_spat = sc$AnnData(t_means)
  gene_boxplot = sc$pl$highest_expr_genes(adata_spat)
  
  return(gene_boxplot)
}

# sandhya_data3 = function(df, df_spatial){
#   
#   ######################################################################################
#   #load packages
#   #reticulate::py_install(c("numpy"))
#   #asssign gene names and rois, and count matrix values (not names from genes)
#   np = import("numpy")
#   pd = import("numpy")
#   scipy.integrate = import("scipy.integrate")
#   math = import("math")
#   plt = import("matplotlib.pyplot")
#   sns = import("seaborn")
#   time = import("time")
#   mp = import("multiprocessing")
#   os = import("os")
#   sc = import("scanpy")
#   anndata = import("anndata")
#   
#   #python
#   #from pack import mod
#   #mod.func()
#   #r
#   # pack <- import("pack")
#   # pack$mod$func()
#   animation = import("matplotlib")$animation 
#   rc = import("matplotlib")$rc 
#   #from matplotlib import animation, rc
#   HTML = import("IPython.display")$HTML 
#   #from IPython.display import HTML
#   zscore = import("scipy.stats")$zscore 
#   #from scipy.stats import zscore
#   TSNE = import ("sklearn.manifold")$TSNE
#   #from sklearn.manifold import TSNE
#   BayesianGaussianMixture = import("sklearn.mixture")$BayesianGaussianMixture 
#   #from sklearn.mixture import BayesianGaussianMixture
#   distance = import("scipy.spatial")$distance
#   #from scipy.spatial import distance
#   euclidean_distances = import("sklearn.metrics.pairwise")$euclidean_distances
#   #from sklearn.metrics.pairwise import euclidean_distances
#   
#   #sc$settings$verbosity = "3"             # verbosity: errors (0), warnings (1), info (2), hints (3)
#   sc$settings$set_figure_params(dpi=100)
#   
#   colours_30 = r_to_py(c("firebrick","gold","royalblue","green","dimgray","orchid","darkviolet",
#                          "red", "orange", "limegreen", "blue", "purple", "seagreen","gold","darkolivegreen",
#                          "lightpink","thistle","mistyrose","saddlebrown","slategrey","powderblue",
#                          "palevioletred","mediumvioletred","yellowgreen","lemonchiffon","chocolate",
#                          "lightsalmon","lightcyan","lightblue", "darkorange","magenta","sienna","midnightblue","fuchsia","violet","tomato","aqua",
#                          "darkslategray","coral","lightcoral","sandybrown","indianred","olivedrab","darkgreen","blueviolet","forestgreen","darkred",
#                          "dimgray","teal","cadetblue"), convert = T)
#   
#   roi_names = colnames(df)[-1] #roi_lymph
#   roi_genes = df$TargetName #genes_lymph
#   
#   roi_data = df[,-1] #lymph_data
#   
#   num_roi = length(roi_names)
#   roi_x_y = df_spatial %>% 
#     select(SegmentDisplayName, ROICoordinateX, ROICoordinateY, !!colnames(df_spatial)[ncol(df_spatial)]) #roi_x_y
#   rearran = roi_data %>%
#     select(!!roi_x_y$SegmentDisplayName) #roi_type
#   
#   #spatial matrix
#   lymph_data_spat = np$copy(roi_data)
#   roi_x_y2 = np$array(roi_x_y[,2:3])
#   ss= euclidean_distances(roi_x_y2, roi_x_y2) %>% data.frame(check.names=F)
#   
#   names(ss) = roi_x_y$SegmentDisplayName
#   test = lapply(ss, function(x){
#     names(x) = roi_x_y$SegmentDisplayName
#     x[which(x<10000)]
#   })
#   
#   means_rois = sapply(test, function(x){
#     roi_data %>% select(!!names(x)) %>%
#       rowMeans()
#   })
#   row.names(means_rois) = roi_genes
#   t_means = t(means_rois)
#   
#   #find out how to get gene names fo rthe plotting
#   adata_spat = sc$AnnData(t_means)
#   
#   #find out how to get gene names fo rthe plotting
#   #gene_boxplot = sc$pl$highest_expr_genes(adata_spat)
#   test = sc$pp$highly_variable_genes(adata_spat, min_mean=0.01, max_mean=8, min_disp=1, n_top_genes=1000, flavor="cell_ranger", n_bins=20)
#   highly_variable = sc$pl$highly_variable_genes(test)
#   
#   sc$pp$neighbors(adata_spat, n_neighbors=30, n_pcs=10, knn=T)
#   sc$tl$leiden(adata_spat,resolution=0.5, random_state=42)
#   
#   return(gene_boxplot)
# }
