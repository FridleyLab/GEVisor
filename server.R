
#make reactive for maximum number of genes > set to max features


shinyServer(function(input, output, session){
  
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
    selectInput("selected_slide", "Choose Slide ID to Analyse",
                choices = slides,
                selected = slides[1])
  })
  
  output$ge_data_preview = renderTable({
    validate(need(nrow(ge_data()$segment) > 1, "Please upload data....."))
    
    head(ge_data()$segment, n=15L)
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
    
    df_spatial = ge_data()$segment %>% filter(SlideName == input$selected_slide)
    df = ge_data()$targetCount %>% select(contains("TargetName"),contains(unique(df_spatial$ScanLabel)))
    nfeatures = input$features
    npcs = input$npcs
    r = input$r
    
    assign("ge_data", ge_data(), envir = .GlobalEnv)
    roi = seurat_louvain(df, df_spatial, nfeatures, npcs, r)
    return(roi)
  })
  
  roi_df = reactive({
    roi_df = roi()$result_df

    

    roi_df
  })
  
  de_markers = reactive({
    #list of dataframes for the different clusters differentially expressed genes
    tmp = louvain_markers(roi()$seuratobj)
  })
  
  color_pal <- reactive({
    pallet = input$color_pallet
    col_pal = color_parse(color_pal = pallet, n_cats=length(unique(roi_df()$cluster)))
  })
  
  output$roi_plot <- renderPlot({

    plot_clusters(roi_df(), color_pal)

    plot_clusters(roi_df(), color_pal())

  })
  
  output$cluster_umap = renderPlot({
    Seurat::DimPlot(roi()$seuratobj, reduction = "umap")
  })
})
