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
    else{
      return(input$mif_image_input$datapath)}
  })
  
  output$upload_image_preview <- renderImage({
    req(ge_image())
    list(
      src    = normalizePath(file.path(ge_image())),
      alt    = "tissue image",
      width  = "50%"
    )}, deleteFile = T)
  
  output$plot_image_preview <- renderImage({
    req(ge_image())
    list(
      src    = normalizePath(file.path(ge_image())),
      alt    = "tissue image",
      width  = "50%"
    )}, deleteFile = T)
})
