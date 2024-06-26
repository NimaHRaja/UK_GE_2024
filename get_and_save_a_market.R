#### reads **a_market** name, gets its data from betfairm and saves the results in **folder**

get_and_save_a_market <- function(a_market, folder){
    
    market_id <- a_market$raw$marketId
    market_name <- gsub("/|\\?", "-",  a_market$raw$marketName)
    event_name <- gsub("/|\\?", "-",  a_market$event$name)
    
    MarketBook_raw <- 
        my_bf$marketBook(marketIds = market_id, getRunners = TRUE)
    
    time <- Sys.time()
    
    file_name <- paste(folder,
                       event_name,
                       "_",
                       market_name,
                       "_",
                       format(time, "%Y%m%d_%H%M%S"),
                       ".rda", 
                       sep = "")
    
    print(file_name)
    
    MarketBook <- 
        list(time = time, 
             Catalogue = a_market,
             MarketBook = MarketBook_raw)
    
    save(MarketBook, file = file_name)
}