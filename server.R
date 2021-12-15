
#make reactive for maximum number of genes > set to max features
#make reactive for maximum number of samples in filtered df > max - 1 for max npcs
#make reactives progress bar active

shinyServer(function(input, output, session){

#import data
  ge_data = reactive({
    if(is.null(input$ge_data_input)){
      return()
    }
    dat = input$ge_data_input
    ext = file_ext(dat$datapath)
    segment = read_xlsx(dat$datapath, sheet = "SegmentProperties")
    targetCount = read_xlsx(dat$datapath, sheet = "TargetCountMatrix")
    dfs = list(segment = segment, targetCount = targetCount)
    #assign("dfs", dfs, envir = .GlobalEnv)
    return(dfs)
  })

  output$choose_slide = renderUI({
    slides = ge_data()$segment$SlideName %>% unique()
    selectInput("selected_slide", "Choose slide ID to analyze",
                choices = slides,
                selected = slides[1])
  })
  
  output$ge_data_preview = renderTable({
    validate(need(nrow(ge_data()$segment) > 1, "Please upload data....."))
    
    head(ge_data()$segment %>% filter(SlideName == input$selected_slide), n=10L)
  })
  
  ge_image = reactive({
    if(is.null(input$mif_image_input)){
      return()
    }
    im = magick::image_read(input$mif_image_input$datapath)
    im2 = magick::image_resize(im, geometry = "500x500") %>%
      image_write(tempfile(fileext='png'), format = 'png')
    print(session$clientData$output$output_upload_image_preview_width)
    #assign("session", session, envir = .GlobalEnv)
    return(im2)
  })
  
#visualize gene expression
  
  gene_names = reactive({
    if(is.null(ge_data())){
      return()
    }
    withProgress(message = "Generating Data List for Gene Menue ", value = 0,{
      incProgress(0.59, detail = "Data for Genes....")
    ge_data()$targetCount %>% pull(TargetName) %>% unique() %>% sort()
  }) })
  
  output$choose_gene = renderUI({
    validate(need(length(gene_names())>1, ""))
    #genes = de_markers() %>% pull(gene)
    withProgress(message = "Generating Gene List ", value = 0,{
      incProgress(0.53, detail = "Data for Genes Plot.....")
    selectInput('select_gene', "Select Gene to View", choices = gene_names(), selected = gene_names()[1], multiple = F)
  }) })
  
  de_markers = reactive({
    withProgress(message = "Generating Data Sets for plotting ", value = 0,{
      incProgress(0.33, detail = "Data for SeuratObj Plot.....")
    #list of dataframes for the different clusters differentially expressed genes
    tmp = louvain_markers(roi()$seuratobj)
    #assign("tmp", tmp, envir = .GlobalEnv)
    return(tmp)
  })
  })
  
  color_pal <- reactive({
    withProgress(message = "Choosing color pallet ", value = 0,{
      incProgress(0.23, detail = "Choosing colors....")
    pallet = input$color_pallet
    col_pal = color_parse(color_pal = pallet, n_cats=length(unique(roi_df()$cluster)))
  }) })
  
  

  # output$ge_plot <- renderPlot({
  #   col_pal = color_parse(color_pal = input$color_pallet, n_cats=8)
  #   
  #   expr_plot(df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(ge_data()$segment$ScanLabel))), 
  #             df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide), 
  #             gene = input$select_gene, 
  #             col_pal = color_pal() 
  #             )
  #   
  # })
  
  ge_image3 = reactive({
    if(is.null(input$mif_image_input)){
      return()
    }
    im = magick::image_read(input$mif_image_input$datapath)
    im2 = magick::image_resize(im, geometry = "500x500") %>%
      image_write(tempfile(fileext='png'), format = 'png')
    print(session$clientData$output$output_upload_image_preview_width)
    #assign("session", session, envir = .GlobalEnv)
    return(im2)
  })
  
  output$ge_image_preview <- renderImage({
    req(ge_image3())
    img = ge_image3()
    width  <- session$clientData$output_upload_image_preview_width
    
    list(src = img, contentType = "image/png")
  }, deleteFile = T)

  output$ge_plot_interactive <- renderGirafe({
    col_pal = color_parse(color_pal = input$color_pallet, n_cats=5)
    
    p1 <- expr_plot_interactive(
      df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(ge_data()$segment$ScanLabel[ge_data()$segment$SlideName == input$selected_slide]))), 
      df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide), 
      gene = input$select_gene, 
      col_pal = color_pal()
      # tooltip = expr
    )
    
    girafe(ggobj = p1)
    
  })

#clustering page
  
  
  color_pal_cluster <- reactive({
    pallet = input$color_pallet_cluster
    col_pal = color_parse(color_pal = pallet, n_cats=length(unique(roi_df()$cluster)))
  })
  
  ge_image2 = reactive({
    if(is.null(input$mif_image_input)){
      return()
    }
    im = magick::image_read(input$mif_image_input$datapath)
    im2 = magick::image_resize(im, geometry = "500x500") %>%
      image_write(tempfile(fileext='png'), format = 'png')
    print(session$clientData$output$output_upload_image_preview_width)
    #assign("session", session, envir = .GlobalEnv)
    return(im2)
  })
  
  output$upload_image_preview <- renderImage({
    req(ge_image())
    img = ge_image()
    width  <- session$clientData$output_upload_image_preview_width
    
    list(src = img, contentType = "image/png")
    }, deleteFile = T)
  
  output$plot_image_preview <- renderImage({
    req(ge_image2())
    img = ge_image2()
    
    list(src = img, contentType = "image/png")
  }, deleteFile = T)
  
  
  
  roi = reactive({
    withProgress(message = "Generating Data Sets for plotting ", value = 0,{
      incProgress(0.33, detail = "Data for Seurat Plot.....")
      
      df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide)
      df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(df_spatial$ScanLabel)))
      nfeatures = input$features
      npcs = input$npcs
      r = input$r
      
      df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide)
      df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(df_spatial$ScanLabel)))
      
      #assign("ge_data", ge_data(), envir = .GlobalEnv)
      roi = seurat_louvain(df, df_spatial, nfeatures, npcs, r)
      return(roi)
    })
  })
  
  roi_df = reactive({
    roi_df = roi()$result_df
    roi_df
  })
  
  output$choose_tooltip = renderUI({
    validate(need(!is.null(roi_df()), "Loading ROI data....."),
             need(!is.null(de_markers()), "Getting differentially expressed genes....."))
    res = roi_df()
    markers = de_markers()
    
    topgenes = markers %>% 
      group_by(cluster) %>% 
      # arrange(p_val_adj, .by_group = TRUE) %>% 
      slice_min(order_by = p_val_adj, n = 5, with_ties = F) %>% 
      select(cluster, gene) %>% 
      mutate(num = seq(n())) %>%
      tidyr::spread(num, gene) %>%
      tidyr::unite("Top DE genes", `1`:`5`, sep = ", ")
    
    
    res = dplyr::full_join(res, topgenes, by='cluster')
    col_names = colnames(res)
    selectInput("selected_tooltip", "Choose Tooltip to be plotted",
                choices = col_names,
                selected = col_names[length(col_names)])
  })
  
  de_markers = reactive({
    withProgress(message = "Generating Plot", value = 0,{
      incProgress(0.33, detail = "Seurat Plot.....")
    #list of dataframes for the different clusters differentially expressed genes
    tmp = louvain_markers(roi()$seuratobj)
  })
  })
  

  tooltip_selected <- reactive({
    input$selected_tooltip
  })
  
  ploting_roi<- reactive({
    plot_clusters(roi_df(), color_pal())
    
  })
  
  
  output$roi_plot_girafe <- renderGirafe({
    validate(need(nrow(roi_df())>1, ""),
             need(length(de_markers()) > 1, ""),
             need(!is.null(color_pal_cluster()), ""),
             need(!is.null(tooltip_selected()), ""))
    ## Can I call output$roi_plot again here instead of the plot_clusters() call?
    withProgress(message = "Generating Plot", value = 0,{
      incProgress(0.33, detail = "Interactive Plot.....")
    girafe(ggobj = plot_clusters_interactive(roi_df(), de_markers(), color_pal_cluster(), tooltip = tooltip_selected()))
    })
  })
  
  umapSeaurat <- reactive({
    Seurat::DimPlot(roi()$seuratobj, reduction = "umap", pt.size = 3, cols = color_pal_cluster())
    
  })
  
  output$cluster_umap = renderPlot({
    validate(need(!is.null(roi()$seuratobj), ""))
    #Seurat::DimPlot(roi()$seuratobj, reduction = "umap", pt.size = 3, cols = color_pal_cluster())
    umapSeaurat()
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(Sys.Date(), '.png', sep='') },
    content = function(file) {
      ggsave(file, plot = umapSeaurat(), device = "png",
             width = 7, height = 7, units = "in")
    }
  )
  
  spatial_decon <- reactive({
    spatialdecon_wrap(roi()$seuratobj)
  })
  
  color_pallet_decon <- reactive({
    pallet = input$color_pallet_decon
    col_pal = color_parse(color_pal = pallet, n_cats=length(unique(roi_df()$cluster)))
  })
  
  decon_spat <- reactive ({
    withProgress(message = "Generating Plot", value = 0,{
      incProgress(0.33, detail = "Interactive Plot.....")
    
    plot_cell_abund(
      spatial_decon(), 
      ge_data()$segment %>% filter(SlideName == input$selected_slide),
      celltype = 'endothelial.cells',
      col_pal = color_pallet_decon()
    )
    
  }) })
  
  output$spatial_decon_plot <- renderPlot({
    decon_spat()
    # plot_cell_abund(
    #   spatial_decon(), 
    #   ge_data()$segment %>% filter(SlideName == input$selected_slide),
    #   celltype = 'endothelial.cells',
    #   col_pal = color_pallet_decon()
    # )
  })

  output$downloadPlot2 <- downloadHandler(
    filename = function() { paste(Sys.Date(), '.png', sep='') },
    content = function(file) {
      ggsave(file, plot = decon_spat(), device = "png",
             width = 7, height = 7, units = "in")
    }
  )
#sandhya page
  sandhya_plot <- reactive ({
    df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide)
    df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(df_spatial$ScanLabel)))
    sandhya_data(
      df_spatial = df_spatial,
      df = df
    )
  })
  
  output$sandhya_firstPlot <- renderPlot({
    sandhya_plot()
  })
  
  sandhya_plot2 <- reactive ({
    df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide)
    df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(df_spatial$ScanLabel)))
    sandhya_data2(
      df_spatial = df_spatial,
      df = df
    )
  })
  
  output$sandhya_secondPlot <- renderPlot({
    sandhya_plot2()
  })
  
  # Show info on the landing/input page
  output$inputpage_info <- renderUI({
    withMathJax({
      k = knitr::knit(input = "inputpage_info.rmd", quiet=T)
      HTML(markdown::markdownToHTML(k, fragment.only=T))
    })
  })
  
})
