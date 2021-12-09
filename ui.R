#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# add for testing

#

#Melanoma was sox10 in the study for tumor stroma
#nicks plotly sort

ui = dashboardPage(
    dashboardHeader(title = "GEVisor"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Importing Data", tabName = 'import', icon = icon('upload')),
            menuItem("GE Visualization", tabName = 'visualization', icon = icon('angle-right')),
            menuItem("GE Clustering", tabName = 'clustering', icon = icon('angle-double-right')),
            tags$br()
            )
        ),
    dashboardBody(
        custom_blue,
        tabItems(
            tabItem(tabName = 'import',
                    h1("GEVisor", align="center"),
                    fluidRow(
                      column(width = 6,
                             fileInput("ge_data_input", "Choose Gene Expression",
                                       multiple = FALSE,
                                       accept = c(c("csv", "xlsx"),
                                                  "Gene Expression Data",
                                                  c(".csv", ".xlsx"))),
                             uiOutput("ge_data_preview")
                      ),
                      column(width = 6,
                             fileInput("mif_image_input", "Choose MIF Image file",
                                       multiple = FALSE,
                                       accept = c(c("png", "tiff"),
                                                  "MIF Image file",
                                                  c(".png", ".tiff"))))
                    ),
            ),
            
            tabItem(tabName = 'visualization',
                    h1("Visualize Differential Gene Expression Data", align="center"),
                    
            ),
            tabItem(tabName='clustering',
                    h1("Gene Expression Clustering", align="center"),
                    
            )
        )
    )
)

