---
title: "ROI clustering info"
author: "Oscar Ospina"
date: "12/15/2021"
output: 
  html_document:
    mathjax: local
    self_contained: false
---



## **Module 2: ROI Clustering**

In this module, Louvain clustering is applied to the gene expression data (via _Seurat_).

Users can modify three parameters:
  1. The clustering resolution.
  2. The number of top variable genes to be used during dimensionality reduction,
  3. The number of PCs to be used during construction of UMAP projection.

The module also computes differentially expressed genes among clusters, and display
the top most differentially expressed genes in the plot when hovering over points.
Users can also display other annotations if available.

