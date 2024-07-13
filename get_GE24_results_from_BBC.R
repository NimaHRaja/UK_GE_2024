library(curl)
library(XML)
library(xml2)
library(dplyr)


###### get list of URLs for 650 constitencies on BBC website


curl_download(
  "https://www.bbc.co.uk/news/election/2024/uk/constituencies",
  "BBC_mainpage.html")

BBC_mainpage <- readLines("BBC_mainpage.html")

constituency_URLs <- 
  lapply(
    unlist(gregexpr("/news/election/2024/uk/constituencies/", BBC_mainpage[24]))[1:650],
    function(x){paste("https://www.bbc.co.uk", substr(BBC_mainpage[24], x, x+46 ), sep = "")
    })


###### lapply over the list and get the results

GE24_results <-
  
do.call(rbind,
        lapply(constituency_URLs,
               function(x){
                 
                 tmp <- tempfile()
                 
                 curl_download(x, tmp)
                 a_constituency_page <- read_html(tmp)
                 
                 results_html_tree <- 
                   htmlTreeParse(a_constituency_page, useInternalNodes = TRUE)
                 
                 
                 data.frame(
                   
                   constituency = 
                     gsub(" - General election results 2024 - BBC News", "",
                          xpathSApply(results_html_tree, 
                                      "//title", 
                                      xmlValue)),
                   
                   candidate = 
                     xpathSApply(results_html_tree, 
                                 "//span[@class='ssrcss-h5cxh6-Title e1j83d2f2']", 
                                 xmlValue),
                   
                   party =
                     xpathSApply(results_html_tree, 
                                 "//span[@class='ssrcss-qqwz3f-Supertitle e1j83d2f3']", 
                                 xmlValue),
                   
                   votes =
                     xpathSApply(results_html_tree, 
                                 "//span[@class='ssrcss-a2di88-ResultValue e1k9l0jz0']", 
                                 xmlValue),
                   
                   share = 
                     xpathSApply(results_html_tree, 
                                 "//span[@class='ssrcss-pjifv6-ResultValue e1k9l0jz0']", 
                                 xmlValue) %>% 
                     matrix(ncol = 2, byrow = TRUE),
                   
                   votes =
                     xpathSApply(results_html_tree, 
                                 "//span[@class='ssrcss-f3y82o-StyledResult enm63mj4']", 
                                 xmlValue) %>% 
                     matrix(ncol = 3, byrow = TRUE) 
                 ) %>%
                   
                   rename(share = share.1, 
                          share_change = share.2, 
                          registered_voters = votes.1, 
                          turnout = votes.2, 
                          turnout_change = votes.3) %>%
                   
                   mutate(party = gsub(",", "", party))
                 
                 
               }
        )
) %>% 
  mutate(votes = as.integer(gsub(",", "", votes))) %>% 
  mutate(share = as.numeric(gsub("%", "", share))) %>% 
  mutate(share_change = as.numeric(share_change)) %>% 
  mutate(registered_voters = as.numeric(gsub(",", "", registered_voters))) %>% 
  mutate(turnout = as.numeric(gsub("%", "", turnout))) %>% 
  mutate(turnout_change = as.numeric(gsub("%", "", turnout_change)))

write.csv(GE24_results, "GE24_results.csv", col.names = FALSE)


# dirty version
#
#
# do.call(rbind,
#         lapply(constituency_URLs[1:2],
#                function(x){
#                  
#                  tmp <- tempfile()
#                  
#                  curl_download(x, tmp)
#                  a_constituency_page <- read_html(tmp)
#                  
#                  readHTMLTable(tmp)[[1]] %>% 
#                    mutate(constituency = 
#                             substr(a_constituency_page, 240,
#                                    unlist(gregexpr(" - General election results 2024 - BBC News", a_constituency_page))[1]-1
#                             ))
#                })
# )
