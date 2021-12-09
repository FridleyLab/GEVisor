##
# This function takes a dataframe with counts and dataframe with spatial coordinates,
# and returns a dataframe with cluster assignments from the Louvain algorithm. The 
# count and spatial dataframes must have a common column, indicating the ROI IDs.
# The function takes also the number of variable genes to consider, the number of PCs
# to use after dimension reduction, and the resolution parameter for the Louvain method
#

seurat_louvain = function(df=NULL, df_spatial=NULL, nfeatures=2000, npcs=30, r=0.8){

  seurat_mtx = as.data.frame(df)

  rownames(seurat_mtx) = seurat_mtx[, 1]
  seurat_mtx = seurat_mtx[, -1]

  SeuratObj = SeuratObject::CreateSeuratObject(seurat_mtx)

  SeuratObj = Seurat::NormalizeData(SeuratObj)
  SeuratObj = Seurat::FindVariableFeatures(SeuratObj, nfeatures=nfeatures)
  SeuratObj = Seurat::ScaleData(SeuratObj, features=rownames(SeuratObj))
  SeuratObj = Seurat::RunPCA(SeuratObj, features=Seurat::VariableFeatures(SeuratObj))
  SeuratObj = Seurat::FindNeighbors(SeuratObj, dims=1:npcs)
  SeuratObj = Seurat::FindClusters(SeuratObj, resolution=r)
  SeuratObj = Seurat::RunUMAP(SeuratObj, dims=1:npcs)
  
  cluster_col = tibble::tibble(roi=names(Seurat::Idents(SeuratObj)), cluster=Seurat::Idents(SeuratObj))
  
  result_df = dplyr::full_join(cluster_col, df_spatial, by=c('roi' = "SegmentDisplayName"))
  result_df = result_df[, c("roi","ROICoordinateX","ROICoordinateY","cluster")]
  colnames(result_df) = c('roi', 'x_pos', 'y_pos', 'cluster')
  
  results = list()
  results[['result_df']] = result_df
  results[['seuratobj']] = SeuratObj
  return(results)
}
