library(twitteR)
library(tidytext)
library(tidyverse)
library(wordcloud)

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tw <- twitteR::searchTwitter("#rstats",
                             n = 1e4)
d <- twitteR::twListToDF(tw)

d_count <- d %>% 
    mutate(number = 1:nrow(d)) %>% 
    select(number, text) %>% 
    unnest_tokens(word, text) %>% 
    anti_join(stop_words) %>% 
    # mutate(word = str_replace(word, "s$", "")) %>% 
    count(word, sort = TRUE) %>% 
    filter(!str_detect(word, "rt|rstats|http|t.co|datascience|data")) %>% 
    arrange(desc(n)) 

d_count %>% 
    with(wordcloud(word, n, max.words = 100))

write.csv(d, "data_raw.csv")
write.csv(d, "data_count.csv")
