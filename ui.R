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
  dashboardSidebar(sidebarMenu(
    menuItem(
      "Importing Data",
      tabName = 'import',
      icon = icon('upload')
    ),
    menuItem(
      "GE Visualization",
      tabName = 'visualization',
      icon = icon('angle-right')
    ),
    menuItem(
      "GE Clustering",
      tabName = 'clustering',
      icon = icon('angle-double-right')
    ),
    menuItem(
      "Spatial Analysis",
      tabName = 'spatial',
      icon = icon('angle-double-right')
    ),
    tags$br()
  )),
  
  dashboardBody(
    custom_blue,
    tabItems(
      tabItem(
        tabName = 'import',
        h1("GEVisor", align = "left"),
        br(),
        fluidRow(
          box(width = 6,
              column(
                width = 12,
                fileInput(
                  "ge_data_input",
                  "Choose Gene Expression",
                  multiple = FALSE,
                  accept = c(c("xlsx"), #"csv",
                             "Gene Expression Data",
                             c(".xlsx"))
                ),
                #".csv",
                uiOutput("choose_slide"),
                div(style = 'overflow-x: scroll; overflow-y: scroll; height:500px; white-space: nowrap', tableOutput('ge_data_preview')),
              )),
          box(
            #id = "image_input_container",
            width = 6,
            column(
              width = 12,
              fileInput(
                "mif_image_input",
                "Choose MIF Image file",
                multiple = FALSE,
                accept = c(c("png", "tiff"),
                           "MIF Image file",
                           c(".png", ".tiff"))
              ),
              imageOutput("upload_image_preview", inline=T, width = "auto"),
            )
          )
        )
      ),
      
      tabItem(
        tabName = 'visualization',
        h1("Visualize Differential Gene Expression Data", align =
             "left"),
        br(),
        uiOutput("choose_gene"),
        selectInput(
          "color_pallet",
          "Choose Color Pallet",
          choices = c(
            "imola" = "imola",
            "discrete rainbow" = "discrete_rainbow",
            "Accent" = "Accent",
            "sunset" = "sunset"
          ),
          selected = "imola"
        ),
        #plotOutput("ge_plot"),
        girafeOutput("ge_plot_interactive")
        
      ),
      
      tabItem(
        tabName = 'clustering',
        h1("Gene Expression Clustering", align = "left"),
        br(),
        fluidRow(
          column(
            width = 6,
            downloadButton('downloadPlot', 'Download Plot'),
            #plotOutput("roi_plot"),
            
            girafeOutput("roi_plot_girafe"),
            sliderInput(
              "r",
              "Resolution",
              min = 0.3,
              max = 3.0,
              value = 0.8
            ),
            sliderInput(
              "features",
              "Features",
              min = 1500,
              max = 3000,
              value = 2000
            ),
            sliderInput(
              "npcs",
              "PC",
              min = 20,
              max = 70,
              value = 30
            ),
            selectInput(
              "color_pallet_cluster",
              "Choose Color Pallet",
              choices = c(
                "imola" = "imola",
                "discrete rainbow" = "discrete_rainbow",
                "Accent" = "Accent"
              ),
              selected = "imola"
            ),
            uiOutput("choose_tooltip"),
            # div(style = 'overflow-x: scroll; overflow-y: scroll; height:500px; white-space: nowrap', tableOutput('ge_data_preview')),
          ),
          box(
            #id = "image_cluster_container",
            width = 6,
            column(
              width = 12,
              imageOutput("plot_image_preview", inline = T),
              br(),
              plotOutput("cluster_umap")
            )
          )
        )
      ),
      tabItem(
        tabName = 'clustering',
        h1("Gene Expression Clustering", align = "left"),
        br(),
        fluidRow(
          column(
            width = 6,
            
          )
        )
      )
    )
  )
)
