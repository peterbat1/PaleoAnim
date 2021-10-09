# Land area, biomes, temperature and precipitation over the last 800,000 years
#
# Data for this app is provided by netCDF files from supplementary in:
#   Krapp, M., R. M. Beyer, S. L. Edmundson, P. J. Valdes, and A. Manica. 2021.
#   A statistics-based reconstruction of high-resolution global terrestrial
#   climate for the last 800,000 years. Scientific Data 8:228.
#
# Peter D. Wilson
# Adjunct Fellow
# Dept. of Biological Sciences
# Faculty of Science and Engineering
# Macquarie University, Sydney, Australia
#
# 2021-09-26; 2021-10-09: Refinements to user interface and styling of "about"
# modal dialog; better colour gradient for precipiation.

library(shiny)
library(shinydashboard)
library(stringr)

basePath <- "/home/peterw/Nyctimene/Climate/Paleoclimate/Krapp_et_al_800k/"

#################################################
ui <- fluidPage(
    title = "Paleo-environment Animation",
    
    ## Method to cause shiny app to stop running when browser (or browser tab)
    ## is closed. See observe() in server function.
    ## Source: Winston Chang https://groups.google.com/g/shiny-discuss/c/JptpzKxLuvU
    ## last accessed 2021-10-08
    tags$script(type = "text/javascript", "
      $(function() { // Run when DOM ready
        $(window).bind('beforeunload', function(e) {
          Shiny.onInputChange('quit', true); // sets input$quit to true
        });
      });
   "),
    
    tags$style('
               tr:nth-child(even) {
               background-color: #D3D3D3;
               }
               
               th {
               background-color: #B0C4DE;
               }
               
               .modal-dialog { width: 50% !important; }'),

    fluidRow(column(12,
                    h1("Paleo-environment Animation (v1.0)"))),
    
    fluidRow(
        column(4,
               selectInput("dataLayer",
                           "Data layer:",
                           c("Land and Land-Ice area",
                             "Mega-biome",
                             "Mean Annual Temperature",
                             "Annual Precipitation")),
               sliderInput("timeStep",
                           "Time step:",
                           min = 1,
                           max = 800,
                           value = 1,
                           step = 1,
                           animate = animationOptions(interval = 150,
                                                      loop = FALSE,
                                                      playButton = "Start",
                                                      pauseButton = "Pause")),
               actionButton("aboutBtn",
                            "About",
                            icon = icon("info"),
                            style = "color: #fff; background-color: #1e9fff; border-color: #2e6da4")),
        column(8,
               fluidRow(imageOutput("paleoMap", inline = TRUE)),
               fluidRow(imageOutput("legend", inline = TRUE)),
               fluidRow(
                   p("Source: Krapp ", em("et al."), " 2021. A statistics-based reconstruction of high-resolution global terrestrial climate for the last 800,000 years. ", em("Scientific Data"), " 8:228. ", br(), "doi:10.1038/s41597-021-01009-3")
               )
        )
    )
)


#################################################
server <- function(input, output) {
    
    thisDataFolder <- reactive({
        if (input$dataLayer == "Land and Land-Ice area") return("www/data/land")
        if (input$dataLayer == "Mega-biome") return("www/data/megabiome")
        if (input$dataLayer == "Mean Annual Temperature") return("www/data/temperature")
        if (input$dataLayer == "Annual Precipitation") return("www/data/precipitation")
    })
    
    thisFile <- reactive({
        #paste0(basePath, thisDataFolder(), "/time_", stringr::str_pad(as.character(input$timeStep), width = 3, pad = "0", side = "left"), ".png")
        paste0(thisDataFolder(), "/time_", stringr::str_pad(as.character(input$timeStep), width = 3, pad = "0", side = "left"), ".png")
    })
    
    output$paleoMap <- renderImage({
        list(src = thisFile(),
             width = 1065,
             contentType = 'image/png')
    }, deleteFile = FALSE)
    
    
    thisLegend <- reactive({
        if (input$dataLayer == "Land and Land-Ice area") return("www/data/legends/land_land-ice_legend.png")
        if (input$dataLayer == "Mega-biome") return("www/data/legends/megabiome_legend.png")
        if (input$dataLayer == "Mean Annual Temperature") return("www/data/legends/temperature_legend.png")
        if (input$dataLayer == "Annual Precipitation") return("www/data/legends/precipitation_legend.png")
    })
    
    output$legend <- renderImage({
        list(src = thisLegend(),
             contentType = 'image/png')
    }, deleteFile = FALSE)
    
    observeEvent(input$aboutBtn, {showModal(modalDialog(
        tags$h2("About this app"),
        tags$p("The animations shown in this app can provide an indication of the changes in the global environment in 1,000 year steps over the past 800,000 years."),
        tags$p("Variables presented in this app include:"),
        tags$ul(tags$li("Land area and land-ice coverage"),
                tags$li("Annual mean temperature"),
                tags$li("Annual precipitation"),
                tags$li("Mega biomes (see details below)")),
        tags$p("They are extracted from the data set produced by:"),
        tags$blockquote("Krapp ", tags$i("et al."), " 2021. A statistics-based reconstruction of high-resolution global terrestrial climate for the last 800,000 years. ", tags$i("Scientific Data"), " 8:228. doi:10.1038/s41597-021-01009-3"),
        tags$p(tags$b("Note these data are indicative only.")),
        tags$p("They are based on only one paleoclimate model, so please interpret with great care."),
        tags$h3("A note on mega biomes"),
        tags$p("A feature of the data set generated by Krapp ", tags$i("et al."), "is the inclusion of inferred biome distribution at each time step using the BIOME4 model due to Kaplan. The output from this model is 28 biomes which leads to a very complex map. Additional challenges come from differing approaches to modelling major vegetation structural types and, most annoyling, differing terminologies for the resulting biomes."),
        tags$p("In an effort to distill a workable classification, Harrison and Prentice (2003, Global Change Biology 9:983-1004. doi:10.1046/j.1365-2486.2003.00640.x) introduced the concept of 'mega biomes' as larger aggregations of biomes. In attempting to make a more useful thumb-nail outline of major vegetation structural types, I have used the cross-reference provided on the PMIP2 web site (https://pmip2.lsce.ipsl.fr/synth/mbmaps.shtml) to re-code the Kaplan model output to approximate Harrison and Prenctice mega biomes."),
        tags$p("The recoding scheme is shown in the follwing table:"),
        tags$table(style="width:60%; margin-left: auto; margin-right: auto;",
                   tags$tr(tags$th(""), tags$th("BIOME4 Kaplan"), tags$th("Mega biome")),
                   tags$tr(tags$td("1"), tags$td("Tropical evergreen forest"), tags$td("Tropical forest")),
                   tags$tr(tags$td("2"), tags$td("Tropical semi-deciduous forest"), tags$td("Tropical forest")),
                   tags$tr(tags$td("3"), tags$td("Tropical deciduous forest/woodland"), tags$td("Tropical forest")),
                   tags$tr(tags$td("4"), tags$td("Temperate deciduous forest"), tags$td("Temperate forest")),
                   tags$tr(tags$td("5"), tags$td("Temperate conifer forest"), tags$td("Temperate forest")),
                   tags$tr(tags$td("6"), tags$td("Warm mixed forest"), tags$td("Warm-temperate forest")),
                   tags$tr(tags$td("7"), tags$td("Cool mixed forest"), tags$td("Temperate forest")),
                   tags$tr(tags$td("8"), tags$td("Cool conifer forest"), tags$td("Boreal forest")),
                   tags$tr(tags$td("9"), tags$td("Cold mixed forest"), tags$td("Boreal forest")),
                   tags$tr(tags$td("10"), tags$td("Evegreen taiga/montane forest"), tags$td("Boreal forest")),
                   tags$tr(tags$td("11"), tags$td("Deciduous taiga/montane forest"), tags$td("Boreal forest")),
                   tags$tr(tags$td("12"), tags$td("Tropical savanna"), tags$td("Savanna and dry woodland")),
                   tags$tr(tags$td("13"), tags$td("Tropical xerophytic shrubland"), tags$td("Grassland and dry shrubland")),
                   tags$tr(tags$td("14"), tags$td("Temperate xerophytic shrubland"), tags$td("Grassland and dry shrubland")),
                   tags$tr(tags$td("15"), tags$td("Temperate sclerophyll woodland"), tags$td("Savanna and dry woodland")),
                   tags$tr(tags$td("16"), tags$td("Temperate broadleaved savanna"), tags$td("Savanna and dry woodland")),
                   tags$tr(tags$td("17"), tags$td("Open conifer woodland"), tags$td("Savanna and dry woodland")),
                   tags$tr(tags$td("18"), tags$td("Boreal parkland"), tags$td("Grassland and dry shrubland")),
                   tags$tr(tags$td("19"), tags$td("Tropical grassland"), tags$td("Grassland and dry shrubland")),
                   tags$tr(tags$td("20"), tags$td("Temperate grassland"), tags$td("Grassland and dry shrubland")),
                   tags$tr(tags$td("21"), tags$td("Desert"), tags$td("Desert")),
                   tags$tr(tags$td("22"), tags$td("Steppe tundra"), tags$td("Tundra")),
                   tags$tr(tags$td("23"), tags$td("Shrub tundra"), tags$td("Tundra")),
                   tags$tr(tags$td("24"), tags$td("Dwarf shrub tundra"), tags$td("Tundra")),
                   tags$tr(tags$td("25"), tags$td("Prostrate shrub tundra"), tags$td("Tundra")),
                   tags$tr(tags$td("26"), tags$td("Cushion-forbs, lichen and moss"), tags$td("Dry tundra")),
                   tags$tr(tags$td("27"), tags$td("Barren"), tags$td("Dry tundra")),
                   tags$tr(tags$td("28"), tags$td("Land ice"), tags$td("Land ice"))),
        tags$p(""),
        tags$hr(style="height:2px;border-width:0;color:gray;background-color:gray"),
        tags$p("This shiny app was written by Peter D. Wilson, Adjunct Fellow, Dept. of Biological Sciences, Faculty of Science and Engineering, Macquarie University, Sydney, NSW, Australia, and Visiting Scientist, Research Centre for Ecosystem Resilience, Royal Botanic Garden, Sydney, NSW, Australia."),
        tags$p("This version released 2021-10-09"),
        title = "",
        easyClose = TRUE,
        footer = actionButton("closeAbout",
                              "Close",
                              style = "color: #fff; background-color: #1e9fff; border-color: #2e6da4"))) })
    
    
    observeEvent(input$closeAbout, { removeModal() })
    
    ## Method to cause shiny app to stop running when browser (or browser tab)
    ## is closed. See tags$script() in ui function.
    ## Source: Winston Chang https://groups.google.com/g/shiny-discuss/c/JptpzKxLuvU
    ## last accessed 2021-10-08
    observe({
        # If input$quit is unset (NULL) do nothing; if it's anything else, quit
        # by invoking stopApp()
        if (is.null(input$quit)) return()
        stopApp()
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
