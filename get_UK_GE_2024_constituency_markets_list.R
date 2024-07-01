source("init.R")

all_politics_events <- 
  my_bf$events(filter = marketFilter(eventTypeIds = 2378961)) 

constituency_events <- 
  all_politics_events[grepl("UK - General Election", 
                            all_politics_events$event_name),] %>% 
  select(event_id) %>% unlist() %>% as.numeric()

constituency_markets <- 
  my_bf$marketCatalogue(
    maxResults = 1000, 
    filter = marketFilter(
      eventIds = constituency_events  
    ))


lapply(constituency_markets, get_and_save_a_market, "data/")
