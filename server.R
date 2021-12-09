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
    df = ffread(infile$datapath, check.names = FALSE, data.table = FALSE)
    return(df)
  })

  output$ge_data_preview = renderTable({
    head(ge_data(), n = 15L)
  })
})