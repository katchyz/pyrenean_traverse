#---- Process GPS Data -----------------------------------------------------####
# Author:       Katarzyna Chyzynska
# Filename:     process_data.R
# Description:  Scripts for preparation of the data in './data' folder.
#               > read GPX files
#               > process as table for 1D plot
#               > process as simple features for 2D plot
#               > save data in './data' folder
# Project:      pyrenean_traverse
#----------------------------------------------------------------------------###


#---- Libraries ------------------------------------------------------------####
library(magrittr)
library(data.table)
library(raster)
library(sf)

#----------------------------------------------------------------------------###


#---- Read and Process Data ------------------------------------------------####

path <- "./data_raw"

# Elevation image
elev_file <- file.path(path, "PYRENEES2.tif")

# GPS tracks
gr10_file <- file.path(path, "gr10_original.gpx")
gr10_var_file <- file.path(path, "gr10_variants.gpx")
gr11_file <- file.path(path, "gr11.gpx")
hrp_file <- file.path(path, "hrp.gpx")


#----------------------------------------------------------------------------###

#---- Process Data for 1D --------------------------------------------------####

# Elevation
elev_img <- elev_file %>% raster::raster()

# GPS
sf_gr10 <- gr10_file %>% sf::st_read(layer = "track_points")
sf_gr11 <- gr11_file %>% sf::st_read(layer = "track_points")
sf_hrp <- hrp_file %>% sf::st_read(layer = "track_points")

sf_gr10_var <- gr10_var_file %>% sf::st_read(layer = "track_points")

add_track_seg_id <- function(track_seg_point_id) {
  idxs <- which(diff(track_seg_point_id) < 0)
  vec <- c()
  i <- 1
  l <- 0
  for (idx in c(idxs, length(track_seg_point_id))) {
    vec <- c(vec, rep(i, idx-l))
    i <- i+1
    l = idx
  }
  return(vec)
}

sf_gr10_var$track_seg_id <- add_track_seg_id(sf_gr10_var$track_seg_point_id)


process_gps_data <- function(sf_gps, elev_img, n = 9) {
  dt_gps <- sf_gps %$%
    cbind(.$track_seg_point_id, st_coordinates(.$geometry)) %>%
    as.data.table()
  dt_gps %<>% set_colnames(c("track_seg_point_id", "lon", "lat"))
  
  dt_gps$ele <- raster::extract(elev_img, dt_gps[,2:3],
                                method = "bilinear") %>%
    round(digits = 2)
  
  if (any(is.na(dt_gps$ele))) {
    idx <- which(is.na(dt_gps$ele))
    dt_gps$ele[idx] <- dt_gps$ele[idx-1]
  }
  
  # smoothed elevation change
  ma <- stats::filter(dt_gps$ele, rep(1/n, n)) %>% .[!is.na(.)]
  dt_gps$ele_smooth <- c(rep(ma[1], floor(n/2)),
                         ma,
                         rep(ma[length(ma)], floor(n/2)))
  
  dt_gps$ele_change <- c(0, diff(dt_gps$ele_smooth))
  dt_gps$ele_gain <- cumsum(ifelse(dt_gps$ele_change > 0, dt_gps$ele_change, 0))
  dt_gps$ele_loss <- cumsum(ifelse(dt_gps$ele_change < 0, dt_gps$ele_change, 0))
  
  dt_gps$hdist <- c(0, distHaversine(dt_gps[,2:3]))
  dt_gps$cum_hdist <- cumsum(dt_gps$hdist)
  
  return(dt_gps)
}

dt_gr10 <- process_gps_data(sf_gr10, elev_img = elev_img, n = 25)
dt_gr10$route <- "GR10"
dt_gr11 <- process_gps_data(sf_gr11, elev_img = elev_img)
dt_gr11$route <- "GR11"
dt_hrp <- process_gps_data(sf_hrp, elev_img = elev_img)
dt_hrp$route <- "HRP"

dt_gps <- rbind(dt_gr10, dt_gr11, dt_hrp)

fwrite(dt_gps, file = './data/dt_gps.csv', sep = ',')

#----------------------------------------------------------------------------###


#---- Process Data for 2D --------------------------------------------------####

track_gr10 <- sf_gr10 %>% st_combine() %>% st_cast(to = "LINESTRING") %>% st_sf()
track_gr11 <- sf_gr11 %>% st_combine() %>% st_cast(to = "LINESTRING") %>% st_sf()
track_hrp <- sf_hrp %>% st_combine() %>% st_cast(to = "LINESTRING") %>% st_sf()

track_gr10_var <- list()
for (id in unique(sf_gr10_var$track_seg_id)) {
  track_gr10_var[[paste0("seg", id)]] <-
    sf_gr10_var[sf_gr10_var$track_seg_id == id,] %>%
    st_combine() %>% st_cast(to = "LINESTRING") %>% st_sf()
}

save(track_gr10, track_gr11, track_hrp, track_gr10_var,
     file = "./data/gps_tracks.Rdata")

#----------------------------------------------------------------------------###


