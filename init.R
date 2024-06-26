#### Installing and loading libraries ####

# devtools::install_github("durtal/betfaiR", force = TRUE)
options(stringsAsFactors = FALSE)
library(betfaiR)
library(dplyr)



#### Connecting to BF API ####

nima_login_data <- 
    read.csv("my_login_data.csv")

my_bf <- betfair(usr = nima_login_data$username, 
                 pwd = nima_login_data$password, 
                 key = as.character(nima_login_data$applicationKey))




#### Sourcing get_and_save_a_market.R

source("get_and_save_a_market.R")