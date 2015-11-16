library(shiny)
source('/srv/shiny-server/apps/twitterParis/oauth.R')
source('/srv/shiny-server/apps/twitterParis/sentiment_sentiment140.R')
shinyServer(function(input, output, session) {

  output$cloudPlot1 <- renderPlot({
    
    # Wordcloud
    wordcloud(corpus.text, min.freq = 3, scale=c(4, 1), 
              colors=brewer.pal(8, "Dark2"),
              random.order = FALSE, max.words = 400)


  })
  
  output$cloudPlot2 <- renderPlot({
    
    # comparison word cloud
    comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
                     scale = c(3, 0.8), random.order = FALSE, title.size = 1.2)
    
    
  })
  
#   output$cloudPlots <- renderPlot({
#     grid.arrange(cloudPlot1, cloudPlot2, ncol=2)
#     
#   })
#   

})
