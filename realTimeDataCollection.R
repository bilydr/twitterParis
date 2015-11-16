library(shiny)
library(magrittr)
library(RSQLite)
library(DBI)
source('~/shinyapps/apps/twitterParis/oauth.R')
setwd("~/data/tweets")
con <- dbConnect(RSQLite::SQLite(), "tweets.sqlite")
register_db_backend(con)


ui <- shinyServer(fluidPage(
  plotOutput("myplot")
))

server <- shinyServer(function(input, output, session){
  # Function to get new observations
  get_new_data <- function(){
    seconds <- round(as.numeric(Sys.time() - start, units= "secs"))
    newT <- search_twitter_and_store("#ParisAttacks", table_name = "tweets", lang ='en')
    totalT <<- totalT + newT
    data <- c(seconds, newT, totalT) # %>% rbind %>% data.frame
    return(data)
  }
  
  # Initialize my_data
  # my_data <- get_new_data()
  start <- Sys.time()
  seconds <- round(as.numeric(Sys.time() - start, units= "secs"))
  totalT <- nrow(dbReadTable(con, "tweets"))
  my_data <- data.frame(time = seconds, newTweets = 0, allTweets = totalT)
  
                        
  # Function to update my_data
  update_data <- function(){
    my_data <<- rbind(get_new_data(), my_data)
  }
  
  # Plot the most recent values
  output$myplot <- renderPlot({
    print("Render")
    invalidateLater(120000, session)
    update_data()
    print(my_data[1:5,])
    plot(newTweets ~ time, data=my_data[1:10,], las=1, type="b")
  })
})

shinyApp(ui=ui,server=server)
