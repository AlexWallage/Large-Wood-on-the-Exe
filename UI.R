

#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      27/02/2025                             ##
##                  Creating a ShinyApp                        ##
##                         UI.R                                ##
##        code by Alex Wallage (aw807@exeter.ac.uk)         ##
#################################################################


    tags$head(
        tags$style(HTML("
            .leaflet-container {
                border-radius: 10px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            }
            .outer {
                position: relative;
                width: 100%;
                height: calc(100vh - 70px);
                padding: 10px;
            }
        "))
), # nolint: error.
    
    # Pop-up modal when the page loads
    tags$script(HTML("
        $(document).ready(function() {
            setTimeout(function() { $('#startupModal').modal('show'); }, 500);
        });
    ")),

div(class="outer",
    leafletOutput("map", height = "calc(100vh - 70px)")
)


