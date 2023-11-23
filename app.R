library(shiny)
library(tidyverse)
library(datateachr)
library(ggplot2)
library(shinyWidgets)

# Replace NA values for cultivar_name with "Unavailable", and dropped NA values in other variables
# (this application tracks only trees that have a plantation record)
vancouver_trees["cultivar_name"][is.na(vancouver_trees["cultivar_name"])] <- "Unavailable"
vancouver_trees <- vancouver_trees %>% drop_na()

# Create diameter range, so that the selection of a diameter if more user-friendly
vancouver_trees <- vancouver_trees %>%
  mutate(diameter_range=case_when(
    diameter <= 2.5 ~ "0-2.5",   # There is an imbalance in the number of
    diameter <= 5 ~ "2.6-5",     # observations per diameter size. It is skewed
    diameter <= 7.5 ~ "5.1-7.5", # towards smaller inches. Thus, it makes sense
    diameter <= 10 ~ "7.6-10",   # to limit the available diameter ranges to a
    diameter <= 20 ~ "11-20",    # a few, and avoid having empty options.
    diameter <= 30 ~ "21-30",
    diameter <= 100 ~ "31-100",
    diameter > 100 ~ "100+"
  ))

# Rearrange the values in diameter range so that they are in ascending order
vancouver_trees$diameter_range <- factor(vancouver_trees$diameter_range,
                                         levels=c("0-2.5", "2.6-5", "5.1-7.5",
                                                  "7.6-10", "11-20", "21-30",
                                                  "31-100", "100+"))
# Define the UI for the application
ui <- fluidPage(

  # Define the title of the application
  titlePanel("Vancouver Tree Plantation Tracker"),

  # Sidebar with selection options. With this, users can select a date range
  # of their choosing, as well as one or multiple diameter ranges of their choosing.
  # This sidebar is intuitive to use and user-friendly, and permit users to select
  # the exact part of the dataset they desire to see
  sidebarLayout(
    sidebarPanel(
      h5("The Vancouver Tree Plantation Tracker permits the listing and spatial
          visualization of trees planted by the city of Vancouver.
          They can be filtered by their year of plantation and diameter."),
      hr(),

      # Select a date range (view all by default)
      dateRangeInput("date_range", "Select a date range: ",
            min = as.Date("1989-10-27"), max = as.Date("2019-07-03"),
            start = as.Date("1989-10-27"), end = as.Date("2019-07-03"),
            format = "yyyy-mm-dd"),
      hr(),

      # Select the diameter range(s) to show in the table and graph (view all by default)
      pickerInput(
        inputId = "selected_diameter",
        label = h5("Select diameter (inches): ", style = "font-weight:bold"),
        choices = levels(factor(vancouver_trees$diameter_range)),
        multiple = TRUE,
        selected = NULL, # all selected initially
        options = list(`actions-box` = TRUE)),
      ),

    # Show the plot and the table. This permits the user to gain access to a
    # table containing all the information available on the data they selected,
    # and to also visualise the data's spatial distribution (longitude and latitude).
    # Both of these are reactive to both the date range and diameter range selected.
    mainPanel(
      plotOutput("id_histogram"),
      dataTableOutput("id_table")
    )
  )
)

# Defines the server logic that determines to create the plot and table
server <- function(input, output) {

  # Filter data based on input
  vancouver_trees_filtered <- reactive(

    # Determines what to show if an input is selected for the diameter feature
    if (!is.null(input$selected_diameter)) {
      vancouver_trees %>%
      filter(diameter_range %in% input$selected_diameter) %>%
      filter(date_planted <= input$date_range[2],
               date_planted >= input$date_range[1])
    }

    # Shows values restricted only by the selected date range
    # if there are no input for the diameter feature
    else {
      vancouver_trees %>%
      filter(date_planted <= input$date_range[2],
             date_planted >= input$date_range[1])
    }
  )

  # Define plot that shows on top
  output$id_histogram <- renderPlot(

    # Plot for when an input is selected for the diameter feature
    if(!is.null(input$selected_diameter)) {
      ggplot(vancouver_trees_filtered(), aes(x = latitude, y = longitude, colour = diameter_range)) +
        geom_point(size=1)+
        theme_bw()+
        ylab("Longitude")+
        xlab("Latitude")+
        guides(color=guide_legend("Diameter range (inches):"))+
        theme(text= element_text(size=25),
              axis.text.x = element_text(face="bold", size = 15),
              axis.text.y = element_text(face="bold", size = 15))
    }

    # Plot for when no input is selected for the diameter feature
    else {
      ggplot(vancouver_trees_filtered(), aes(x = latitude, y = longitude)) +
        geom_point(size=0.1)+
        theme_bw()+
        ylab("Longitude")+
        xlab("Latitude")+
        theme(text= element_text(size=25),
              axis.text.x = element_text(face="bold", size = 15),
              axis.text.y = element_text(face="bold", size = 15))
    }
  )

  # Define table that shows at bottom
  output$id_table <- renderDataTable(
    vancouver_trees_filtered(),
    options = list(pageLength = 5, scrollX = TRUE))

}

# Run the application
shinyApp(ui = ui, server = server)
