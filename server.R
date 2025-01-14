server <- function(input, output, session) {
  
  dt_gps <- reactive({ data_gps })
  trace_gr10 <- reactive({ track_gr10 })
  trace_gr11 <- reactive({ track_gr11 })
  trace_hrp <- reactive({ track_hrp })
  trace_gr10_var <- reactive({ track_gr10_var })
  
  dt_gps_filtered <- reactive({
    active_routes <- c()
    if (input$switch_gr10) active_routes <- c(active_routes, "GR10")
    if (input$switch_gr11) active_routes <- c(active_routes, "GR11")
    if (input$switch_hrp) active_routes <- c(active_routes, "HRP")
    
    # Filter the data
    dt_gps()[route %in% active_routes]
  })
  
  # elevation plot
  output$elevation_plot <- renderPlotly({
    
    ele_max <- as.character(round(max(dt_gps_filtered()$ele)))
    
    plot_1D <-
      ggplot(dt_gps_filtered(),
             aes(x = cum_hdist/1000, y = ele, colour = route,
                 text = sprintf(
                   "Distance: %.1f km<br>Elevation: %.1f m<br>Elevation gain: %.0f m", 
                   cum_hdist/1000, ele, ele_gain),
                 group = 1)) +
      scale_colour_manual(values = color_palette) +
      geom_line() +
      scale_x_continuous(expand = expansion(mult = c(0, 0)),
                         labels = \(x) paste0(x, " km")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0))) +
      theme_minimal() +
      theme(axis.title = element_blank(),
            axis.line.y = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            panel.grid = element_blank(),
            legend.position = "none",
            plot.margin = margin(0, 0, 0, 0)) +
      guides(colour = guide_legend(override.aes = list(size = 10)))
    
    plotly_1D <- plot_1D %>%
      ggplotly(tooltip = "text", source = "elevation_plot") %>%
      layout(hovermode = "x unified",
             hoverlabel = list(bgcolor = 'rgba(255,255,255,0.75)', font = list(size = 10)),
             margin = list(l = 0, r = 0, t = 30, b = 0),
             yaxis = list(automargin = FALSE, fixedrange = TRUE),
             annotations = list(list(x = 7, y = 2700, font = list(size = 12),
                                     text = sprintf("%s m", ele_max),
                                     showarrow = FALSE))) %>%
      event_register("plotly_hover") %>%
      event_register("plotly_unhover")
    
    plotly_1D
    
  })
  
  # Create the map
  output$map_2D <- renderLeaflet({
    
    plot_2D <- leaflet() %>%
      addProviderTiles("OpenStreetMap.France", group = "OSM France") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      addLayersControl(baseGroups = c("OSM France", "Satellite"),
        options = layersControlOptions(collapsed = TRUE))
    
    if (input$switch_gr10) {
      plot_2D %<>% addPolylines(data = trace_gr10(),
                                color = as.character(color_palette["GR10"]),
                                opacity = 0.9)
      for (el in trace_gr10_var()) {
        plot_2D %<>%
          addPolylines(data = el,
                       color = as.character(color_palette["GR10_var"]),
                       opacity = 0.9)
      }
    }

    if (input$switch_gr11) {
      plot_2D %<>% addPolylines(data = trace_gr11(),
                                color = as.character(color_palette["GR11"]),
                                opacity = 0.9)
    }
    
    if (input$switch_hrp) {
      plot_2D %<>% addPolylines(data = trace_hrp(),
                                color = as.character(color_palette["HRP"]),
                                opacity = 0.9)
    }
    
    plot_2D
    
  })
  
  # update map with plotly hover events
  observe({
    event <- event_data("plotly_hover", source = "elevation_plot")
    if (!is.null(event)) {
      hover_distance <- event$x*1000
      
      hover_points <- dt_gps_filtered()[, 
                           .SD[which.min(abs(cum_hdist - hover_distance))], 
                           by = route]
      
      leafletProxy("map_2D") %>%
        clearGroup("hover_markers") %>%
        addCircleMarkers(
          data = hover_points,
          lng = ~lon,
          lat = ~lat,
          group = "hover_markers",
          radius = 8,
          color = ~as.character(color_palette[route]),
          fillOpacity = 0.8
        )
    }
  })
  
  # clear markers with plotly unhover
  observe({
    event <- event_data("plotly_unhover", source = "elevation_plot")
    if (!is.null(event)) {
      leafletProxy("map_2D") %>%  # Fixed map ID
        clearGroup("hover_markers")
    }
  })
  
  outputOptions(output, "elevation_plot", suspendWhenHidden = FALSE)
  outputOptions(output, "map_2D", suspendWhenHidden = FALSE)
  
}
