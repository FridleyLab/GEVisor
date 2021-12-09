## 
# Script to run louvain clustering
#


#countsfp = ('./data/hu_colon_count_results/Export3_BiologicalProbeQC.xlsx')
#df = readxl::read_excel(countsfp, sheet=3)
#nfeatures = 2000
#npcs = 30
#roiid = 'SegmentDisplayName'
#x_col = 'ROICoordinateX'
#y_col = 'ROICoordinateY'
#df_spatial = readxl::read_excel(countsfp, sheet=1)

# countsfp = ('./data/hu_colon_count_results/Export3_BiologicalProbeQC.xlsx')
# df = readxl::read_excel(countsfp, sheet=3)
# nfeatures = 2000
# npcs = 30
# roiid = 'SegmentDisplayName'
# x_col = 'ROICoordinateX'
# y_col = 'ROICoordinateY'
# df_spatial = readxl::read_excel(countsfp, sheet=1)

# df_spatial = df_spatial[, c(roiid, x_col, y_col)]
# col_pal = 'sunset'
# 
# res = seurat_louvain(df, df_spatial, nfeatures, npcs)
# col_pal = color_parse(col_pal, n_cats=length(unique(res$cluster)))
# plot_clusters(res, col_pal)



