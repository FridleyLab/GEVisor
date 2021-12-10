##
#
# @param res, a Seurat object. Second item of list output from louvain_clusters
#

spatialdecon_wrap = function(res){
  cell_profile=SpatialDecon::safeTME
  res@active.assay='Spatial'
  names(res@assays) = 'Spatial'
  deconv_res = SpatialDecon::runspatialdecon(object=res, bg = 0.01, X=cell_profile, align_genes=TRUE)
}
