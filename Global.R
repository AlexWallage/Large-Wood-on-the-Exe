
#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##  # nolint
##                  Creating a ShinyApp                        ##
##                        Global.R                             ##
##        code by Alex Wallage (aw807@exeter.ac.uk)            ##
#################################################################


## G1 Load large wood, river, and bridge data ----

# vector
lw_points <- st_read("assets/LWonExe.shp")
river <- st_read("assets/RiverExeDissolved.shp")
bridges <- st_read("assets/BridgesWithin50mofExe.shp")
clusters <- st_read("assets/clusters.shp")
extent <- st_read("assets/ExeExtent.shp")
catcher <- st_read("assets/LargeWoodCatchers.shp")

# raster
heatmap <- rast("assets/Heatmap1000m_4326_11m.tif")
dem  <- rast("assets/Hillshade_Exe_4326_111m.tif")


#Convert vectors to CRS 4326
lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
clusters <- st_transform(clusters, crs = 4326)
extent <- st_transform(extent, crs = 4326)
catcher <- st_transform(catcher, crs = 4326)

dem <- aggregate(dem, fact = 1)
heatmap <- aggregate(heatmap, fact = 2)

river <- st_zm(river)

# Dynamically generate colours based on number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), domain = clusters$CLUSTER_ID)

pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), na.color = "transparent")

pal_dem <- colorNumeric(palette = "Greys", domain = na.omit(values(dem)), na.color = "transparent")


# Dynamically generate colors based on the number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))

# If the number of clusters exceeds 12, we use a different palette (e.g., "Set3" or "Spectral").
if (num_clusters <= 12) {
    pal_clusters <- colorFactor(
        palette = brewer.pal(num_clusters, "Paired"),  # Use the Paired palette for up to 12 clusters
        domain = clusters$CLUSTER_ID
    )
} else {
    pal_clusters <- colorFactor(
        palette = colorRampPalette(brewer.pal(9, "Set1"))(num_clusters),  # Extend for more clusters
        domain = clusters$CLUSTER_ID
    )
}

# Dynamically generate colors using colorRamp
pal_clusters <- colorFactor(
    palette = colorRamp(c("#2bccc4", "#2424ee")),  # Custom color gradient from red to blue
    domain = clusters$CLUSTER_ID
)