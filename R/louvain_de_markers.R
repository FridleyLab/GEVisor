##
# This function takes a Seurat object and performs differential gene expression 
# analysis among clusters. The result is a list of dataframes, one for each cluster,
# with p-values, logFC, of each gene, sorted by the most to the less differentially
# expressed gene for ewach cluster, with respect to the others.
#

louvain_markers = function(res, min.pct=0.25){

  markers = Seurat::FindAllMarkers(res)
  topmarkers = list()
  for(cluster in unique(markers$cluster)){
    topmarkers[[cluster]] = markers[markers$cluster == cluster, ]
  }

  return(markers)
}
