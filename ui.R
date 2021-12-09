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
            tags$br(),
            fluidRow(column(12, align="center",
                            tags$br(),
                            tags$img(src = "moffitt-logo.png",
                                     position = "absolute",
                                     bottom = "25px",
                                     width = "100px", 
                                     height = "100px")
                            )
                     )
            )
        ),
    dashboardBody(
        custom_blue,
        tabItems(
            tabItem(tabName = 'import',
                    h1("iTIME", align="center"),
                    
            ),
            
            tabItem(tabName = 'visualization',
                    h1("Univariate Summary and Visualization", align="center"),
                    
            ),
            tabItem(tabName='clustering',
                    h1("Multivariate Summary and Visualization", align="center"),
                    
            )
        )
    )
)

