library(dplyr)
library(sf)
library(leaflet)
library(shinythemes)
library(RColorBrewer)
library(shinyWidgets)
library(rsconnect)
library(shiny)
library(highcharter)
library(htmlwidgets)
library(RColorBrewer)
library(shinycssloaders)
###################################################################################################

myAusdata_by_month_sf = readRDS("myAusdata_by_month.rds") #load data to use in 'Map' tab

myAusdata_by_month_5 = readRDS("myAusdata_by_month_5.rds") #load data to use in 'Story' tab

areas_by_weeks = readRDS("areas_by_weeks.rds") #load data to use in 'Heatmap' tab

# Options for Spinner
options(spinner.color="#c51b7d", spinner.type = 7, spinner.size=3)

ui <- shinyUI(
 
  navbarPage(
    title = "Australians' Mobility Changes During COVID",
    theme = shinytheme("yeti"),
    
    tabPanel("Map",
             div(class = "outer",
                 tags$head(
                   includeCSS("styles.css")
                 ),
                 
                leafletOutput("map", width = "100%", height = "100%"),
                 
                 absolutePanel(bottom = 30, left = 250, draggable = TRUE,
                              
                # slider title, step increments
                sliderTextInput("choices", "Select month:", choices = unique(myAusdata_by_month_sf$month),
                animate = animationOptions(interval = 1500, loop = FALSE), grid = TRUE, selected = "March", width = 500))  
                
                #Note that for the Firefox browser the selected state "March" is not applied when the page loads (which it should) on the "Maps" default page. 
                #The app works fine in IE and Chrome with the data loaded for March displaying in the app when the app loads.
                #If you know how I can fix that please let me know! I currently have an open issue on Stack Overflow for this which I do not have response/solution for yet.

          
                 
             ),
             
               tags$div(id = "cite",
                      'Data downloaded from Facebook for Good by Jodie Anderson (2020).'
             )
    ),
    
    tabPanel("Story",
             
             highchartOutput("timeline", height = "800px" ) %>% withSpinner(),
             includeMarkdown("analysis.md"),
             
             br()
    ),
    
    tabPanel("Heatmap",
             
            highchartOutput("heatmap", height = "100%") %>% withSpinner(),
            includeMarkdown("heatmap.md"),
            br()
    ),
 
    tabPanel("About",
             includeMarkdown("about.md"),
             br()
    )
    

  )
  
  
)


# Define server logic
server <- function(input, output, session) {
  
  
    filteredData <- reactive({
        myAusdata_by_month_sf %>%
            filter(month %in% input$choices)
    })
    

    popup <-  reactive({
       
             sprintf("%s: %.1f%%", filteredData()$polygon_name, filteredData()$AvRelChange*100)

    })
    
    output$map <- renderLeaflet({
      

        mypalette <- colorNumeric(palette = "PuOr", domain = myAusdata_by_month_sf$AvRelChange, na.color = "transparent")
        
                leaflet(myAusdata_by_month_sf) %>%
                    setView(134, -29, 4) %>%
            addProviderTiles("Esri.WorldGrayCanvas") %>%
                     addLegend(pal=mypalette, values=~AvRelChange, opacity=1, title = "Mobility Change (%)", position = "bottomleft",
                              labFormat = labelFormat(prefix = "(", suffix = ")", between = ", ", 
                                                      transform = function(x) 100 * x))

    })
    
    observe({
        
      mypalette <- colorNumeric(palette = "PuOr", domain = myAusdata_by_month_sf$AvRelChange, na.color = "transparent")
        
         leafletProxy("map", data = filteredData()) %>%
            clearShapes() %>%
            addPolygons(fillColor = ~mypalette(AvRelChange),
                        stroke=TRUE,
                        fillOpacity = 1, 
                        color = "grey",
                        weight = 0.3,
                        label = popup(), labelOptions = labelOptions(
                          style = list("font-weight" = "normal", padding = "2px 2px"),
                          textsize = "13px",
                          direction = "auto", offset = c(10, -15)))
      
    }) 
    
    output$timeline <- renderHighchart ({
      
      hc <- myAusdata_by_month_5 %>%
        hchart ('spline', hcaes(x= date, y=AvRelChange, group=NAME_1)) %>%
        hc_colors(brewer.pal(8, "Dark2")) %>%
        hc_title(text="Australians' Mobility Changes", style=list(fontWeight="bold", fontSize="30px"),align="left") %>%
        hc_subtitle(text="During the coronavirus pandemic", style=list(fontWeight="bold"), align="left") %>%
        hc_xAxis(title = list(text=NULL), plotBands = list(list(label = list(text = "Australia<br>in<br>lockdown"), color = "rgba(100, 0, 0, 0.1)",from = datetime_to_timestamp(as.Date('2020-03-16', tz = 'UTC')),
            to = datetime_to_timestamp(as.Date('2020-03-31', tz = 'UTC'))))) %>%
        hc_yAxis(title=list(text = "Mobility Change (%)"), showLastLabel = FALSE, labels = list(format = "{value}%")) %>%
        hc_caption(text = "The Change in Mobility metric looks at how much people are moving around and compares it to a baseline period that predates most social distancing measures.<br> 
The baseline period for this dataset is the four weeks of February 2020 (i.e. from the 2nd to the 29th).", useHTML = TRUE)%>%
        hc_credits(text = "www.highcharts.com", href = "www.highcharts.com", enabled = TRUE, style = list(fontSize="10px")) %>%
        hc_tooltip(distance = 30, crosshairs = TRUE, shared = TRUE, borderWidth = 2, valueSuffix = "%") %>%
        hc_navigator(enabled = TRUE) %>%
        hc_rangeSelector(enabled = TRUE) %>%
        hc_plotOptions(series = list(marker = list(enabled = FALSE), lineWidth = 4))
      
      hc
      
     })
    
    
    output$heatmap <- renderHighchart  ({
      
      hc1 <- areas_by_weeks %>%
        hchart(type = "heatmap", hcaes(x = date, y = polygon_name, value = AvRelChange)) %>%
        hc_title(text="Australians' Mobility Changes", style=list(fontWeight="bold", fontSize="30px"), align="left") %>%
        hc_subtitle(text="During the coronavirus pandemic", style=list(fontWeight="bold"), align="left") %>%
        hc_boost(useGPUTranslations = TRUE) %>%
        hc_size(height = 5000, width = 550) %>%
        hc_colorAxis(labels = list(format = '{value}%'), stops = color_stops(10, rev(brewer.pal(10, "PiYG")))) %>%
        hc_legend(itemMarginTop = 75, layout = "vertical", verticalAlign = "top", align = "right", valueDecimals = 0) %>%
        hc_xAxis(labels = list(enabled = FALSE), tickInterval = 5, title = NULL, lineWidth = 0, tickLength = 20) %>%
        hc_yAxis(title=list(text = ""), reversed = TRUE, gridLineWidth = 0) %>%
        hc_tooltip(distance = 20, pointFormat = '{point.date} <br> {point.polygon_name}: <b>{point.value} %') %>%
        hc_credits(position = list(align = 'center', x = 135, y = -4), text = "www.highcharts.com", href = "http://www.highcharts.com", enabled = TRUE, style = list(fontSize="10px")) %>%
        hc_caption(align = 'center', text = "The white in the heatmap represent gaps in data.", useHTML = TRUE)
        
      hc1                                    
      
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
