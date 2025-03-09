
#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ## # nolint
##                  Creating a ShinyApp                        ##
##                         App.R                               ##
##        code by Alex Wallage (aw807@exeter.ac.uk)            ##
#################################################################


setwd("D:/Backup/OneDrive - University of Exeter/MSc GIS/GEOM184_Open_Source_GIS/Practical6") # nolint

# Load packages ----
library(shiny)
library(leaflet)
library(sf)
library(raster)
library(ggplot2)
library(ggiraph)
library(RColorBrewer)
library(terra)
library(leafem)

options(shiny.maxRequestSize = 1000000 * 1024^2)


# ----

# Run global script containing all your relevant data ----
source("Global.R")

# Define UI for visualisation ----
source("UI.R")

ui <- navbarPage("Instream large wood on the River Exe", id = "nav", # nolint
                tabPanel("Map", # nolint
                          div(class="outer", # nolint
                              leafletOutput("map", height = "calc(100vh - 70px)") # nolint
                          ) # nolint
                ) # nolint
)

# Define the server that performs all necessary operations ----
server <- function(input, output, session) {
  source("Server.R", local = TRUE)
}

# Run the application ----
shinyApp(ui, server)
