# map tab

map_tab <-
  tabItem("tab_map",
          fluidRow(
            column(2, style = "height: 4vh;", div(class = "switch-gr10",
                          materialSwitch(inputId = "switch_gr10", label = "GR10",
                                         status = NULL, value = TRUE))),
            column(2, style = "height: 4vh;", div(class = "switch-gr11",
                          materialSwitch(inputId = "switch_gr11", label = "GR11",
                                         status = NULL, value = TRUE))),
            column(2, style = "height: 4vh;", div(class = "switch-hrp",
                          materialSwitch(inputId = "switch_hrp", label = "HRP",
                                         status = NULL, value = TRUE)))
            ),
          fluidRow(column(12, style = "height: 25vh;",
                   plotlyOutput("elevation_plot", height = "100%"))),
          fluidRow(column(12, style = "height: 50vh;",
                          leafletOutput("map_2D", height = "100%"))))
