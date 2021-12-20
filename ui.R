#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

ui = dashboardPage(
  dashboardHeader(title = "GEVisor"),
  dashboardSidebar(
    sidebarMenu(
      menuItem(
        "Importing Data",
        tabName = 'import',
        icon = icon('upload')
      ),
      menuItem(
        "1. GE Visualization",
        tabName = 'visualization',
        icon = icon('dna')
      ),
      menuItem(
        "2. GE Clustering",
        tabName = 'clustering',
        icon = icon('glyphicon glyphicon-equalizer', lib='glyphicon')
      ),
      menuItem(
        "3. GE Deconvolution",
        tabName = 'deconvolution',
        icon = icon('circle')
      ),
      menuItem(
        "4. Spatial Analysis",
        tabName = 'spatial',
        icon = icon('map')
      ),
      tags$br()
    )
  ),
  
  dashboardBody(
    custom_blue,
    tabItems(
      tabItem(
        tabName = 'import',
        br(),
        fluidRow(
          box(
            width = 12,
            status = "primary",
            column(
              width = 12,
              uiOutput("inputpage_info")
            )
          )
        ),
        fluidRow(
          box(
            width = 6,
            #status = "primary",
            column(
              width = 12,
              fileInput(
                "ge_data_input",
                "Choose gene expression/annotation file",
                multiple = FALSE,
                accept = c(c("xlsx"), #"csv",
                           "Gene Expression Data",
                           c(".xlsx"))
              ),
              #".csv",
              uiOutput("choose_slide"),
              div(style = 'overflow-x: scroll; overflow-y: scroll; height:500px; white-space: nowrap', tableOutput('ge_data_preview')),
            )
          ),
          box(
            #id = "image_input_container",
            width = 6,
            #status = "primary",
            column(
              width = 12,
              fileInput(
                "mif_image_input",
                "Choose immunoflourescent image file",
                multiple = FALSE,
                accept = c(c("png", "tiff"),
                           "MIF Image file",
                           c(".png", ".tiff"))
              ),
              imageOutput("upload_image_preview", inline = T, width = "auto"),
            )
          )
        )
      ),
      
      tabItem(
        tabName = 'visualization',
        br(),
        fluidRow(
          box(
            width = 12,
            status = "primary",
            column(
              width = 12,
              uiOutput("geneexpr_info")
            )
          )
        ),
        fluidRow(
          width = 12,
          box(
            width = 6,
            #status = "primary",
            girafeOutput("ge_plot_interactive"),
            uiOutput("choose_gene"),
            selectInput(
              "color_pallet",
              "Choose color palette",
              choices = c(
                "Yellow/Orange" = "YlOrBr",
                "Discrete Rainbow" = "discrete_rainbow",
                "Blue/Red" = "BuRd",
                "Sunset" = "sunset"
              ),
              selected = "sunset"
            ),
          ),
          box(width = 6,
              #status = "primary",
              imageOutput("ge_image_preview", inline = T, width = "auto"),
          )
        )
      ),
      
      tabItem(
        tabName = 'clustering',
        br(),
        fluidRow(
          box(
            width = 12,
            status = "primary",
            column(
              width = 12,
              uiOutput("clusterpage_info")
            )
          )
        ),
        fluidRow(
          box(
            width = 6,
            column(
              width = 12,
              girafeOutput("roi_plot_girafe"),
            )
          ),
          box(width = 6,
              #status = "primary",
              imageOutput("plot_image_preview", inline = T, width = "auto"),
          ),
        ),
        fluidRow(
          box(
          textInput(
            "r",
            "Resolution",
            value = "0.8",
            width = "50%"
          ),
          textInput(
            "features",
            "Features",
            value = "2000",
            width = "50%"
          ),
          textInput(
            "npcs",
            "PCs",
            value = 30,
            width = "50%"
          ),
          selectInput(
            "color_pallet_cluster",
            "Choose color palette",
            choices = c(
              "Okabe-Ito" = "okabe ito",
              "Discrete Rainbow" = "discrete_rainbow",
              "Muted" = "muted",
              "Light" = "light"
            ),
            selected = "discrete_rainbow"
          ),
          uiOutput("choose_tooltip"),
          # div(style = 'overflow-x: scroll; overflow-y: scroll; height:500px; white-space: nowrap', tableOutput('ge_data_preview')),
        ),
          box(
            #id = "image_cluster_container",
            width = 6,
            column(
              width = 12,
              downloadButton('downloadPlot', 'Download Plot'),
              # imageOutput("plot_image_preview", inline = T),
              # br(),
              plotOutput("cluster_umap")
            )
          )
        )
      ),
      tabItem(
        tabName = 'deconvolution',
        br(),
        fluidRow(
          box(
            width = 12,
            status = "primary",
            column(
              width = 12,
              uiOutput("deconvpage_info")
            )
          )
        ),
        fluidRow(
          # selectInput(
          #   "color_pallet_decon",
          #   "Choose Color Pallet",
          #   choices = c(
          #     "imola" = "imola",
          #     "discrete rainbow" = "discrete_rainbow",
          #     "Accent" = "Accent",
          #     "sunset" = "sunset"
          #   ),
          #   selected = "imola"
          # ),
          box(
            width = 6,
            column(
              width = 12,
              plotOutput("spatial_decon_plot"),
              downloadButton('downloadPlot2', 'Download Plot')
            )
          ),
          box(width = 6,
              status = "primary",
              imageOutput("deconv_image_preview", inline = T, width = "auto"),
          )
        )
      ),
      tabItem(
        tabName = 'spatial',
        h1("Spatial Analysis", align = "left"),
        br(),
        fluidRow(column(width = 6,
                        plotOutput(
                          "sandhya_firstPlot"
                        )),
                 column(
                   width = 6,
                   plotOutput("sandhya_secondPlot")
                 ))
      )
    )
  )
)
