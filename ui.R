library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Tweets WordClouds - #ParisAttacks "),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width =2,
        p('This app brings in the latest 1000 tweets with #ParisAttacks into analysis'),
        helpText("it may take a long while to show the results")
#       selectInput("lang", "Language:",
#                   choices = c('EN', 'FR')),
# 
#       sliderInput("tweets",
#                   "Number of recent tweets:",
#                   min = 10,
#                   max = 100,
#                   value = 30, 
#                   step = 10),
#       
#       submitButton(text = "Update")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3('Word Cloud - Most Frequent Words'),
      plotOutput("cloudPlot1", height = 600),
      # br()
      h3('Sentiment Cloud'),
      plotOutput("cloudPlot2", height = 800)
    )
  )
))
