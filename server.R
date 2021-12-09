# iteractive Tumor Immune MicroEnvironment
# 
# iTIME Shiny Application is a tool to visualize spatial IF data that is output from HALO. 
# Along with clinical data, brief summary statistics are presented.
#
# Dev team in ui.R
#clinical_data = fread("example_data/deidentified_clinical.csv", check.names = FALSE, data.table = FALSE)
#summary_data = fread("example_data/deidentified_summary.csv", check.names = FALSE, data.table = FALSE)
#summary_data_merged = merge(clinical_data, summary_data, by = "deidentified_id")

shinyServer(function(input, output) {
  ge_data = reactive({
    if(is.null(input$ge_data_input)){
      return()
    }
    dat = input$ge_data_input
    ext = file_ext(dat$datapath)
    #validate(need(ext %in% c("csv", "xlsx"), "Please upload a CSV or XLSX file....."))
    if(ext == "csv"){
      df = fread(dat$datapath, check.names=F, data.table = F)
      print("csv")
    } else {
      df = read_xlsx(dat$datapath, check.names = F, sheet = 1) %>% data.frame(check.names=F)
      print("excel")
    }
    #assign("df", df, envir = .GlobalEnv)
    return(df)
  })

  
  output$ge_data_preview = renderTable({
    validate(need(nrow(ge_data()) > 1, "Please upload data....."))
    
    head(ge_data(), n=15L)
  }, width = "200px")
})