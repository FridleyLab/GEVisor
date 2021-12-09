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
    ext = file_ext(input$ge_data_input)
    validate(need(ext %in% c("csv", "xlsx"), "Please upload a CSV or XLSX file....."))
    if(ext == "csv"){
      df = fread(infile$datapath, check.names=F, data.table = F)
    } else {
      df = read.xlsx(infile$datapath, check.names = F)
    }
    return(df)
  })

  output$ge_data_preview = renderTable({
    head(ge_data(), n = 15L)
  })
})