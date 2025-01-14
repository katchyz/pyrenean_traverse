dashboardPage(
  dashboardHeader(
    title = "The Pyrenean Traverse",
    tags$li(class = "dropdown title", tags$h1("The Pyrenean Traverse"))
  ),
  dashboardSidebar(collapsed = FALSE,
    sidebarMenu(
      menuItem("Information", tabName = "tab_info", icon = icon("circle-info")),
      menuItem("Maps", tabName = "tab_map", icon = icon("map")),
      menuItem("3D View - beta", tabName = "tab_3D", icon = icon("cube"))
    )
  ),
  dashboardBody(
    tags$head(
      # Reset favicon
      tags$link(rel = "shortcut icon", href = "#"),
      # Compiled css file
      tags$link(rel = "stylesheet", type = "text/css", href = "css/sass.min.css")
    ),
    tabItems(
      info_tab,
      map_tab,
      threeD_tab
    )
  )
)

