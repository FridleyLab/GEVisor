# iteractive Tumor Immune MicroEnvironment
# 
# iTIME Shiny Application is a tool to visualize spatial IF data that is output from HALO. 
# Along with clinical data, brief summary statistics are presented.
#
# Dev team in ui.R
#clinical_data = fread("example_data/deidentified_clinical.csv", check.names = FALSE, data.table = FALSE)
#summary_data = fread("example_data/deidentified_summary.csv", check.names = FALSE, data.table = FALSE)
#summary_data_merged = merge(clinical_data, summary_data, by = "deidentified_id")

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

  
  output$ge_data_preview = renderTable({
    validate(need(nrow(ge_data()$segment) > 1, "Please upload data....."))
    
    head(ge_data()$segment, n=15L)
  })
  
  ge_image = reactive({
    if(is.null(input$mif_image_input)){
      return()
    }
    im = magick::image_read(input$mif_image_input$datapath)
    im2 = magick::image_resize(im, geometry = "1000x1000")
      return(im2)
  })
  
  output$upload_image_preview <- renderPlot({
    req(ge_image())
    plot(ge_image())
    })
  
  # output$plot_image_preview <- renderImage({
  #   req(ge_image())
  #   list(
  #     src    = normalizePath(file.path(ge_image())),
  #     alt    = "tissue image",
  #     width  = "50%"
  #   )}, deleteFile = T)
  
  roi = reactive({
    
    df = ge_data()$targetCount
    df_spatial = ge_data()$segment
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
  
  color_pal <- reactive({
    pallet = input$color_pallet
    col_pal = color_parse(color_pal = pallet, n_cats=length(unique(roi_df()$cluster)))
  })
  
  output$roi_plot <- renderPlot({

    plot_clusters(roi_df(), color_pal)

    plot_clusters(roi_df(), color_pal())

  })
})
