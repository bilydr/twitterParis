
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Twitter WordCloud - #ParisAttacks "),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(width =2,
      selectInput("lang", "Language:",
                  choices = c('EN', 'FR')),

      sliderInput("tweets",
                  "Number of recent tweets:",
                  min = 10,
                  max = 100,
                  value = 30, 
                  step = 10),
      
      submitButton(text = "Update")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3('Word Cloud - English'),
      plotOutput("cloudPlot1"),
      # h3('Sentiment Cloud - English'),
      plotOutput("cloudPlot2", height = 600)
    )
  )
))
