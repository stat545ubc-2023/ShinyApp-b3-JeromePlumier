# Vancouver Tree Plantation Tracker

This contains the information relating to the shiny-app created to track the trees planted by the city of Vancouver.

This app was created for completion of Assignment B3 of the course STAT545B offered by the University of British Columbia Assignment B-3 of STAT545B.

The app can be found at this link: <https://jeromeplumier.shinyapps.io/ShinyApp-b3-JeromePlumier/>

## Content Description

-   `README.md`: This file. It contains information concerning the app.

-   `app.R`: This holds the R code for generating the shiny-app.

## App Description

The Vancouver Tree Plantation Tracker permits the listing and spatial visualization of trees planted by the city of Vancouver. Users can filter by the year of plantation and diameter of the trees.

The user can change two inputs:

1.  Date range - Users can select what date range to show in the graph and the table. The default is the first date that plantation was recorded (1989-10-27) to the last date that plantation was recorded in the dataset (2019-07-03). Dates outside of this range can not be selected. Users may either type in the date (in YEAR-MONTH-DAy format) or click the box and select the date from a calendar view.

2.  Diameter range - Users can select which diameter range to view in the graph and table. The default is all diameter ranges are selected. Diameter ranges that are currently selected have a check-mark next to them. For convenience, there is a *Select all* and *Deselect all* option.

### Features

The following three features were selected for this assignment:

1.  The separation of the application into a main panel and a side panel, for aesthetic purposes.

2.  Allow the user to search for multiple entries simultaneously - The app allows for users to view results for multiple diameter ranges at the same time.

3.  Allow the user to search for multiple entries simultaneously - The app allows for users to view results for multiple date ranges at the same time.

4.  Add parameters to the plot - The app takes in selected diameter ranges and selected date range as input. The plot updates based on these inputs.

5.  Add parameters to the table - The app takes in selected diameter ranges and selected date range as input. The table updates based on these inputs.

## Data

The data used here is included in the `datateachr` R package. This can be installed in R by the `install.packages()` function.
