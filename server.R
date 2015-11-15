
library(shiny)
source('/srv/shiny-server/apps/twitterParis/oauth.R')
source('/srv/shiny-server/apps/twitterParis/tweetsmining.R')
shinyServer(function(input, output, session) {

  output$cloudPlot1 <- renderPlot({
    
    # Wordcloud
    wordcloud(corpus.text, min.freq = 2, scale=c(4, 1), 
              colors=brewer.pal(8, "Dark2"),
              random.order = FALSE, max.words = 400)


  }, width = 500, height = 500)
  
  output$cloudPlot2 <- renderPlot({
    
    # comparison word cloud
    comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
                     scale = c(3, 0.5), random.order = FALSE, title.size = 1.2)
    
    
  })
  
  

})
