# info tab

# info_tab <- tabItem("tab_info",
#                     img(src = "pyrenees.jpg", height = "20%", align = "right"))

info_tab <-
  tabItem("tab_info",
          fluidRow(
            column(width = 6,
                   box(width = NULL, title = "Routes Traversing the Pyrenees",
                       p("There are three iconic long-distance hiking routes
                         traversing the Pyrenees mountain range,
                         from the Atlantic to the Meditteranean.
                         The GR10 is a French trail, the GR11 spans Spain,
                         and the HRP offers a high-altitude, border-crossing adventure."),
                       tags$br(),
                       p(style = sprintf("color: %s; font-weight: bold; margin: 0 0 5px;",
                                         color_palette[["GR10"]]),
                         "GR10"),
                       tags$hr(style = sprintf("margin-top: 0px; margin-bottom: 10px;
                                               border-top: 1px solid %s;",
                                               color_palette[["GR10"]])),
                       tags$ul(style = "list-style: none;",
                         tags$li("Distance: ~913 km"),
                         tags$li("Elevation gain: ~57,000 m")
                       ),
                       p("The GR10, running entirely in France, stretches from
                         Hendaye in the west to Banyuls-sur-Mer
                         in the east, traversing verdant valleys,
                         lush meadows, and picturesque villages.
                         It is well-marked with frequent accommodation options,
                         such as gîtes and refuges, and regular opportunities
                         for resupply in villages."),
                       p("See ",
                         tags$a("here", href = "https://gr10.org/", target="_blank",
                                style = paste0("color: ", color_palette[["GR10"]], "; text-decoration: underline")),
                         "for more information (in french)."),
                       tags$br(),
                       p(style = sprintf("color: %s; font-weight: bold; margin: 0 0 5px;",
                                         color_palette[["GR11"]]),
                         "GR11"),
                       tags$hr(style = sprintf("margin-top: 0px; margin-bottom: 10px;
                                               border-top: 1px solid %s;",
                                               color_palette[["GR11"]])),
                       tags$ul(style = "list-style: none;",
                               tags$li("Distance: ~855 km"),
                               tags$li("Elevation gain: ~38,000 m")
                       ),
                       p("On the Spanish side, the GR11 runs parallel
                         from Irún to Cap de Creus, winding through arid and rugged
                         landscapes, dramatic peaks, and remote alpine lakes,
                         showcasing Spain’s diverse terrain.
                         GR11 offers similar infrastructure to GR10, with a mix of refuges,
                         hostels, and villages along the way, though some sections
                         require careful planning for longer stretches between services."),
                       p("See ",
                         tags$a("here", href = "https://travesiapirenaica.com/gr11/gr11.php", target="_blank",
                                style = paste0("color: ", color_palette[["GR11"]], "; text-decoration: underline")),
                         "for more information (in spanish and english)."),
                       tags$br(),
                       p(style = sprintf("color: %s; font-weight: bold; margin: 0 0 5px;",
                                         color_palette[["HRP"]]),
                         "HRP"),
                       tags$hr(style = sprintf("margin-top: 0px; margin-bottom: 10px;
                                               border-top: 1px solid %s;",
                                               color_palette[["HRP"]])),
                       tags$ul(style = "list-style: none;",
                               tags$li("Distance: ~850 km"),
                               tags$li("Elevation gain: ~52,000 m")
                       ),
                       p("The HRP (Haute Randonnée Pyrénéenne), a high-altitude route
                       from Hendaye to Banyuls-sur-Mer, weaves along the spine of the Pyrenees,
                       frequently crossing the border between France, Spain and Andorra.
                       It is the most challenging and remote route of the three,
                       with fewer marked trails and less frequent accommodation or resupply points,
                       demanding greater self-sufficiency and logistical preparation."))),
            column(width = 6,
                   box(width = NULL,
                       tags$img(
                         src = "pyrenees2.jpg",
                         style = "width: 100%; height: auto; max-width: 800px;")),
                   box(width = NULL,
                       tags$img(
                         src = "pyrenees3.jpg",
                         style = "width: 100%; height: auto; max-width: 800px;")))))


