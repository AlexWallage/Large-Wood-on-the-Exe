#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ## # nolint
##                  Creating a ShinyApp                        ##
##                       Server.R                              ##
##        code by Alex Wallage (aw807@exeter.ac.uk)            ##
#################################################################

# Render leaflet map ----
output$map <- renderLeaflet({
  leaflet() %>%
    setView(lng = -3.518843866911701,
            lat = 50.87389783827717,
            zoom = 10.0) %>%
    addProviderTiles(providers$Esri.WorldImagery,
    group = "Colour" # nolint
    ) %>%
    addPolylines(data = river,
                color = "blue", # nolint
                weight = 2,
                opacity = 0.8,
                group = "River"
    ) %>%
    addRasterImage(dem,
                    colors = pal_dem, # nolint
                    opacity = 0.1,
                    group = "DEM"
    ) %>%
    addRasterImage(heatmap,
                    colors = pal_heatmap, # nolint
                    opacity = 0.7,
                    group = "heatmap"
    ) %>%
    addPolygons(data = extent,
                color = "black", # nolint
                weight = 3,
                group = "extent"
    ) %>%
    addLayersControl(
      baseGroups = c("Colour"),
      overlayGroups = c("River", "Bridges", "Large Wood", "catcher", "heatmap"),
      options = layersControlOptions(collapsed = FALSE)
    )
})

# Add Popups
observe({
  leafletProxy("map") %>%
    clearMarkers() %>%
    addCircleMarkers(data = clusters,
                    fillColor = ~pal_clusters(CLUSTER_ID), # nolint
                    color = "black",
                    weight = 1,
                    radius = 8,
                    stroke = TRUE,
                    fillOpacity = 0.8,
                    popup = ~paste("<b>Type:</b>",
                                    LWtype, "<br><b>Imagery used:</b>", # nolint
                                    SatImgProv, "<br><b>Cluster ID:</b>",
                                    CLUSTER_ID),
                    group = "Large Wood") %>% # nolint

    addMarkers(data = bridges,
                icon = icons(iconUrl="assets/bridges.png", # nolint
                              iconWidth = 30,
                              iconHeight = 30),
                              popup = ~paste("<b>Bridge:</b>", # nolint
                                    BRIDGE.NAM, # nolint
                                    "<br><b>Owner:</b>",
                                    OWNER,
                                    "<br><b>Location:</b>",
                                    EASTING + NORTHING
                    ), # nolint
                    group = "Bridges") %>%

    addCircleMarkers(data = catcher,
                      fillColor = "red", # nolint
                      color = "black",
                      popup = ~paste(),
                      group = "catcher")
})

# Add Legend
observe({
  leafletProxy("map") %>%
    clearControls() %>%
    addLegend(
      position = "bottomright",
      pal = pal_clusters,
      values = clusters$CLUSTER_ID,
      title = "Cluster ID",
      opacity = 1
    ) %>%
    # Legend for Heatmap
    addLegend(
      position = "bottomleft",  # Adjusted to avoid overlap
      pal = pal_heatmap,
      values = values(heatmap), # Use the raster values for the heatmap
      title = "Heatmap Intensity",
      opacity = 0.7,
      labFormat = labelFormat(transform = function(x) round(x, 2)) # Format labels
    )
})

# Show Popup on App Start
observe({
  showModal(modalDialog(
    title = "GEOM184: Open-Source GIS: Large-Wood on the River Exe",
    "This GIS web-app allows you to explore the outputs of Open-Source GIS analysis performed on the River Exe for large wood. Large wood was digitised using Google and Bing composite satellite images, and spatial analysis was performed using QGIS and R. Based on risk to infrastructure, large wood catchers are suggested in the map. click off of this window to close it.", # nolint
    easyClose = TRUE,
    footer = NULL
  ))
})
