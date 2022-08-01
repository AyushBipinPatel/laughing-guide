##### This script is to scrape State wise revenue collection data from WIKI pedia



# libraries ---------------------------------------------------------------

library(here)
library(tidyverse)
library(rvest)



# scrape prep -------------------------------------------------------------

url <- "https://en.wikipedia.org/wiki/Goods_and_Services_Tax_(India)_Revenue_Statistics#State-Wise_Monthly_Revenue_Collections"



tibble(
  x_part1 = rep('//*[@id="mw-content-text"]/div[1]/table[',36),
  seq_x = c(2:37),
  x_part2 = rep("]",36),
  xpath = paste(x_part1,seq_x,x_part2,sep = "")
) -> tibble_xpaths

tibble(
  x_part1 = rep('//*[@id="mw-content-text"]/div[1]/h5[',36),
  seq_x = c(1:36),
  x_part2 = rep("]",36),
  xpath = paste(x_part1,seq_x,x_part2,sep = "")
) -> tibble_statename


# function to scrape data -------------------------------------------------

scrape_gst_collection <- function(xp_tab, xp_st){
  read_html(url) %>% 
    html_element(xpath = xp_tab) %>% 
    html_table(header = F,trim = T) %>% 
    filter(X1 != "Month") %>% 
    rename(month = X1, collection_20_21 = X4, 
           collection_19_20 = X6, collection_18_19 = X8) %>% 
    select(-c(X2,X3,X5,X7,X9)) %>% 
    mutate(
      across(.cols = collection_20_21:collection_18_19,
             .fns = ~as.numeric(
               str_extract(.x, "(?<=[:punct:])[:digit:]{1,}(?= )")
             )
      )
    ) -> temp_data
  
  read_html(url) %>% 
    html_element(xpath = xp_st) %>% 
    html_text() ->st_name
  
  temp_data$state <- rep(st_name,12)
  
  return(temp_data)
  
  
}


# map the function to get data --------------------------------------------


map2_dfr(.x = tibble_xpaths$xpath,
         .y = tibble_statename$xpath,
         .f = scrape_gst_collection
         ) -> data_gst_collection_statewise


# state wise yearly total -------------------------------------------------

data_gst_collection_statewise %>% 
  group_by(state) %>% 
  summarise(
    collection_20_21 = sum(collection_20_21, na.rm = T),
    collection_19_20 = sum(collection_19_20, na.rm = T),
    collection_18_19 = sum(collection_18_19, na.rm = T)
  ) -> gst_state_summary


# save data ---------------------------------------------------------------

write_csv(gst_state_summary,
          here("data/15_data_summary_state_gst_collection.csv"))

write_csv(data_gst_collection_statewise,
          here("data/16_data_monthly_state_gst_collection.csv"))






