## example codes from 
## http://www.r-bloggers.com/create-twitter-wordcloud-with-sentiments/
## http://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/
## https://www.credera.com/blog/business-intelligence/twitter-analytics-using-r-part-2-create-word-cloud/
## http://stackoverflow.com/questions/18153504/removing-non-english-text-from-corpus-in-r-using-tm


# package setup-----------------------------------------------------------------
# old package 'sentiment' used - currently not on CRAN but can be installed from archive
require(devtools)
install_url("http://cran.r-project.org/src/contrib/Archive/Rstem/Rstem_0.4-1.tar.gz")
install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")

library(twitteR)
library(RCurl)
library(stringr)
library(tm)
library(wordcloud)
library(sentiment)

### tm functions preparation -------------------------------------------------------------


clean.text <- function(some_txt)
{
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt) # remove RT or via + username
  some_txt = gsub("@\\w+", "", some_txt)  # remove @UserName
  some_txt = gsub("[[:punct:]]", "", some_txt)  # Remove punctuation
  some_txt = gsub("[[:digit:]]", "", some_txt) 
  some_txt = gsub("http\\w+", "", some_txt) #remove links
  some_txt = gsub("[ \t]{2,}", "", some_txt)  # Remove tabs
  some_txt = gsub("^\\s+|\\s+$", "", some_txt) #blank spaces 
  some_txt = gsub("amp", "", some_txt) #remove ampersand
  # define "tolower error handling" function
  try.tolower = function(x)
  {
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y)
  }
  
  some_txt = sapply(some_txt, try.tolower)
  some_txt = some_txt[some_txt != ""]
  names(some_txt) = NULL
  return(some_txt)
}

removeNonASCII <- function(text){
  
  
  removeFun <- function(dat1) {
    # convert string to vector of words
    dat2 <- unlist(strsplit(dat1, split=" "))
    # find indices of words with non-ASCII characters
    dat3 <- grep("dat2", iconv(dat2, "latin1", "ASCII", sub="dat2"))
    # subset original vector of words to exclude words with non-ASCII char
    if (length(dat3) > 0){
      dat2 <- dat2[-dat3]
    } 
    # convert vector back to a string
    dat1 <- paste(dat2, collapse = " ")
    
    return(dat1)
  }
  
  text <- sapply(text, removeFun)
  names(text) <- NULL
  return(text)

}

# Get Data ----------------------------------------------------------------

keyword <- '#ParisAttacks'
n <- 30

# get some tweets
tweets <- searchTwitter(keyword, n, lang= "en")
# get text 
tweet_txt <- sapply(tweets, function(x) x$getText())

# clean text
tweet_clean <- clean.text(tweet_txt)
tweet_clean <- removeNonASCII(tweet_clean)
corpus.text <- Corpus(VectorSource(tweet_clean))
tweet_num <- length(tweet_clean)

# data frame (text, sentiment)
tweet_df <- data.frame(text = tweet_clean, sentiment = rep("", tweet_num), 
                       stringsAsFactors=FALSE)


# apply function getSentiment
tweet_df$sentiment <- classify_emotion(tweet_clean)[,7]


# delete rows with no sentiment
tweet_df  <-na.omit(tweet_df)

#separate text by sentiment
sents <- levels(factor(tweet_df$sentiment))
#emos_label <- emos


# get the labels and percents
labels <-  lapply(sents, function(x) paste(x,format(round((length((tweet_df[tweet_df$sentiment ==x,])$text)/length(tweet_df$sentiment)*100),2),nsmall=2),"%"))

nemo <- length(sents)
emo.docs <- rep("", nemo)

for (i in 1:nemo)
{
  tmp = tweet_df[tweet_df$sentiment == sents[i],]$text
  
  emo.docs[i] = paste(tmp, collapse=" ")
}


# remove stopwords

emo.docs <- removeWords(emo.docs, stopwords("english"))
# emo.docs <- removeWords(emo.docs, stopwords("french"))
corpus.senti <- Corpus(VectorSource(emo.docs))
tdm <- TermDocumentMatrix(corpus.senti)
tdm <- as.matrix(tdm)
colnames(tdm) <- labels


