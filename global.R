# packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(bslib)
library(magrittr)
library(raster)
library(sf)
library(data.table)
library(geosphere)
library(ggplot2)
library(plotly)
library(leaflet)
#library(rayshader)
#library(rgl)

# colors
color_palette <- c(main = "#172201",
                   supp = "#5B6C7B",
                   bckg = "#D2D5DA",
                   GR10 = "#2eb89a", GR10_var = "#6BC7B3",
                   GR11 = "#b8552e",
                   HRP = "#2e4cb8")

# data
data_gps <- read.csv("./data/dt_gps.csv") %>% setDT()
load("./data/gps_tracks.Rdata")
# elev_data <- "./data/PYRENEES2.tif" %>% raster::raster()

# compile sass to css
sass::sass(
  sass::sass_file("styles/main.scss"),
  "www/css/sass.min.css",
  cache = NULL,
  options = sass::sass_options(output_style = "compressed")
)

# # modules
# plot_elevation <- use("modules/plot_elevation.R")

# tab pages
source("pages/info_tab.R")
source("pages/map_tab.R")
source("pages/threeD_tab.R")
