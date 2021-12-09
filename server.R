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
  # sheet_names = reactive({
  #   validate(need(!is.null(input$ge_data_input), ""))
  #   if(file_ext(input$ge_data_input$datapath) == "csv"){
  #     return(c("CSV File"))
  #   }
  #   validate(need(file_ext(input$ge_data_input$datapath) == "xlsx", "Only for Excel Files"))
  #   dat = input$ge_data_input
  #   nam = excel_sheets(dat$datapath)
  #   print(nam)
  #   return(nam)
  # })
  # 
  # output$sheet_picker = renderUI({
  #   validate(need(length(sheet_names()) > 0, "XLSX Columns"))
  #   selectInput("picked_sheet", "Choose Sheet of Excel to Import",
  #               choices = sheet_names(),
  #               selected = sheet_names()[1])
  # })
  
  ge_data = reactive({
    if(is.null(input$ge_data_input)){
      return()
    }
    dat = input$ge_data_input
    ext = file_ext(dat$datapath)
    #validate(need(ext %in% c("csv", "xlsx"), "Please upload a CSV or XLSX file....."))
    #if(ext == "csv"){
    #  df = fread(dat$datapath, check.names=F, data.table = F)
    #  print("csv")
    #} else {
    segment = read_xlsx(dat$datapath, sheet = "SegmentProperties")
    targetCount = read_xlsx(dat$datapath, sheet = "TargetCountMatrix")
    #  print("excel")
    #}
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
      return(input$mif_image_input$datapath)}})
  
  
  output$image <- renderImage({
    req(ge_image())

    # width = session$clientData$output_image_width
    # height = session$clientData$output_image_height
    # print(width)
    # print(height)
    # 
    # pixelratio <- session$clientData$pixelratio
    # outfile <- tempfile(fileext='.png')
    # 
    # png(outfile, width = width*pixelratio, height = height*pixelratio,
    #     res = 72*pixelratio)
    # hist(rnorm(input$obs))
    # dev.off()
    # 
    list(
      src    = normalizePath(file.path(ge_image())),
      alt    = "tissue image",
      width  = "50%"
    )}, deleteFile = T)
})
