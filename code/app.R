library(readr)
library(migest)
library(circlize)
library(countrycode)
library(tidyverse)
library(ggrepel)
library(ggmap)
library(dplyr)
library(gganimate)
library(ggplot2)
library(RColorBrewer)
library(maps)
library(ggspatial)
library(leaflet)
library(osmdata)
library(sf)
library(ggthemes)
library(shiny)
library(gt)
library(countrycode)

us_dot_air_intl_2023 <- read_csv("../data/us-dot-air-intl-2023.csv")

airports <- read.csv("../data/airports.dat")
airlines <- read.csv("../data/airlines.dat")
countries <- read_csv("../data/countries.dat", col_names = FALSE)

colnames(airports) <- c("AirportID", "Name", "City", "Country", "IATA", "ICAO", "Latitude", "Longitude", "Altitude", "Timezone", "DST", "TimeRegion")

colnames(countries) <- c("Name", "ISO_Code", "DAFIF_Code")

colnames(airlines) <- c("OpenFlightsID", "Name", "Alias", "IATA", "ICAO", "Callsign", "Country", "Active")

countries$region <- countrycode(sourcevar = countries$Name,
                                origin = "country.name",
                                destination = "region")
countries <- countries %>% group_by(region) %>% drop_na()

airports$region <- countrycode(sourcevar = airports$Country,
                               origin = "country.name",
                               destination = "region")

airlines$region <- countrycode(sourcevar = airlines$Country,
                               origin = "country.name",
                               destination = "region")

airports <- airports %>% drop_na(IATA)

us_airports <- airports[grep("United States", airports$Country), ]

intlTravel_2022 <- us_dot_air_intl_2023 %>% filter(Year == 2022 | Year == 2021)

us_dot_air_intl_2023 <- us_dot_air_intl_2023 %>%
  left_join(airports %>% 
              select(IATA, us_long = Longitude, us_lat = Latitude), 
            by = c("usg_apt" = "IATA")) %>%
  left_join(airports %>% 
              select(IATA, fg_long = Longitude, fg_lat = Latitude), 
            by = c("fg_apt" = "IATA"))

us_dot_air_intl_2023$us_long <- as.numeric(us_dot_air_intl_2023$us_long, na.rm = TRUE)
us_dot_air_intl_2023$us_lat <- as.numeric(us_dot_air_intl_2023$us_lat, na.rm = TRUE)
us_dot_air_intl_2023$fg_long <- as.numeric(us_dot_air_intl_2023$fg_long, na.rm = TRUE)
us_dot_air_intl_2023$fg_lat <- as.numeric(us_dot_air_intl_2023$fg_lat, na.rm = TRUE)

AirlineTable <- merge(us_dot_air_intl_2023, airlines[, c("IATA", "Country", "region", "Name")], 
                      by.x = "carrier", by.y = "IATA") %>% na.omit()

us_dot_air_intl_2023 <- merge(us_dot_air_intl_2023, airports[, c("IATA", "Country", "region")], 
                              by.x = "fg_apt", by.y = "IATA", all.x = TRUE) 

poproutes <- us_dot_air_intl_2023 %>%
  group_by(Year, Month, usg_apt, fg_apt, us_long, us_lat, fg_long, fg_lat, Country, region) %>% 
  summarize(count = sum(Total)) %>% 
  arrange(Year, desc(count))

poproutes <- poproutes %>% na.omit()

poproutesPrev <- us_dot_air_intl_2023 %>% filter(Year == 2022) %>%
  group_by(Year, Month, usg_apt, fg_apt, us_long, us_lat, fg_long, fg_lat, Country, region) %>% 
  summarize(count = sum(Total)) %>% 
  arrange(Year, desc(count))

popair <- AirlineTable %>%
  group_by(Year, Month, carrier, Name, usg_apt, fg_apt, us_long, us_lat, fg_long, fg_lat, Country, region) %>% 
  summarize(count = sum(Total)) %>% 
  arrange(Year, desc(count)) %>% na.omit()

# SHINY APP
ui <- fluidPage(
  titlePanel("U.S. International Travel Volume By Passenger Counts"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput(inputId = "selectedIATA",
                     label = "Choose the IATA (3 letter) codes for airports you'd like to filter by!",
                     choices = airports$IATA,
                     multiple = TRUE,
                     selected = NULL),
      radioButtons(inputId = "filterType",
                   label = "Choose how you'd like to filter!",
                   choices = c("Include", "Exclude"),
                   selected = "Include"),
      selectInput("year", "Select Year:", choices = 1990:2022),
      selectInput("month", "Select Month:", choices = month.name, selected = NULL),
    ),
    submitButton("Update Results!")
    
  ),
  mainPanel(
    plotOutput(outputId = "graph"),
    dataTableOutput(outputId = "table")
    
  )
)

server <- function(input, output, session) {
  
  updateSelectizeInput(session, 'selectedIATA', 
                       choices = unique(airports$IATA), 
                       server = TRUE)
  
  poproutes2 <- reactive({
    filtered_routes <- poproutes %>%
      filter(Year == input$year)
    if (!is.null(input$selectedIATA) && length(input$selectedIATA) > 0) {
      if (input$filterType == "Include") {
        filtered_routes <- filtered_routes %>%
          filter(usg_apt %in% input$selectedIATA | fg_apt %in% input$selectedIATA)
      } else {
        filtered_routes <- filtered_routes %>%
          filter(!(usg_apt %in% input$selectedIATA | fg_apt %in% input$selectedIATA))
      }
    }
    filtered_routes
  }) 
  
  output$graph <- renderPlot({
    routes_data <- poproutes2()
    ggplot() +  
      borders("world", colour = "gray85", fill = "gray80") +
      theme_map() + 
      geom_curve(data = routes_data, aes(x = us_long, y = us_lat, xend = fg_long, yend = fg_lat, size = count), color = "green", alpha = 0.02) +
      geom_point(data = routes_data, aes(x = us_long, y = us_lat), color = "black", size = 1) + 
      geom_point(data = routes_data, aes(x = fg_long, y = fg_lat), color = "black", size = 1) + 
      scale_size_continuous(name = "Number of Passengers", range = c(0.5, 5)) + guides(size = guide_legend(override.aes = list(alpha = 0.5, size = 1))) +
      labs(x = "Longitude", y = "Latitude", title = "Number of Passengers Flying With U.S. Airports", subtitle = paste("Year:", input$year))
  })
}
shiny_app <- shinyApp(ui = ui, server = server)