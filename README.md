# GEVisor
Visualization of gene expression data from GeoMx-DSP experiments

Welcome everyone! This is the GEVisor 2021 Moffitt Hackathon GitHub page.

If it is of interest to utilize R for parts of this project (mostly for the Shiny side of things), it is recommended to [download the appropriate version of R for your operating system from CRAN](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjOipHdmtX0AhWTSDABHe2EBvYQFnoECAoQAQ&url=https%3A%2F%2Fcran.r-project.org%2F&usg=AOvVaw0pGNScRjIdSkNXK6Ky1j_m). Additionally, a great GUI for R is [RStudio which can be downloaded here](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjl8N-Im9X0AhVWQjABHfWWCGMQFnoECAwQAQ&url=https%3A%2F%2Fwww.rstudio.com%2F&usg=AOvVaw1bt9MYkG-ySe7hgo9R8XTb). Both of this make a powerful environment for working on projects.

Some useful packages that we can leverage when workin within R are:
1. edgeR
2. limma
3. spatialGE
4. Seurat
5. tidyverse

If you are versed in downloading packages from repositories other than CRAN, feel free to install spatialGE (`devtools::install_github()`) and edgeR and limma (`BiocManager::install()`), otherwise we can install them tomorrow.

In addition to previously mentioned packages, we may explore implementation of the [SpaGCN](https://github.com/jianhuupenn/SpaGCN) algorithm (Python) to detect differentially expressed genes. 

GeoMx Data Downloads:
1. Colon - [Download](https://external-soa-downloads-p-1.s3.us-west-2.amazonaws.com/hu_colon_count_results.tar.gz)
2. Lymph - [Download](https://external-soa-downloads-p-1.s3.us-west-2.amazonaws.com/hu_lymph_node_count_results.tar.gz)

For some reading about analyzing the spatial data GeoMx, here is a link to the vignette for [GeoMx analysis using spatialGE](https://fridleylab.github.io/spatialGE/articles/read_GeoMx_output.html)
