#### Extracting total_matched from betfair market data

results <- 
  do.call(
    rbind,
    lapply(paste("data/", list.files("data/"), sep = "") ,
           function(x){
             load(x)
             data.frame(
               total_matched = MarketBook$MarketBook[[1]]$raw$totalMatched,
               constituency = MarketBook$Catalogue$raw$marketName) 
           }))

# write.csv(results, "constituency_totalmatched_27JUN24.csv", row.names = FALSE)
