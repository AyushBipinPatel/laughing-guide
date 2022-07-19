####### To get data of number of seats for every state for general elections


# lilbr -------------------------------------------------------------------

library(here)
library(tidyverse)
library(rvest)


# url to page -------------------------------------------------------------


tibble(
  ls_ge = c(16:1),
  index = c(0:15),
  url = paste("http://loksabhaph.nic.in/Members/statear.aspx?lsno=",
              ls_ge,"&tab=",index,sep="")
) -> url_ge_1_16

# /html/body/form/div[3]/div[5]/div/div[1]/table/tbody/tr/td[2]/div[2]/div/table/tbody/tr/td/table/tbody/tr[1]/td/table
# 
# member_list_table
# 
# /html/body/form/div[3]/div[5]/div/div[1]/table/tbody/tr/td[2]/div[2]/div/table/tbody/tr/td/table/tbody/tr[3]/td/table


# scrape ------------------------------------------------------------------


scrape_data_ls <- function(url,pass_ge){
  
  read_html(url) %>% 
    html_elements(".member_list_table") %>% 
    html_table(header = T,trim = T) -> tab_list 
  
  colnames(tab_list[[1]]) <- c("srn","states","n_seats")
  
  colnames(tab_list[[2]]) <- c("srn","states","n_seats")
  
  reduce(tab_list,rbind) -> data_scrape
  
  data_scrape %>% 
    mutate(
      ge = pass_ge
    )
  
  
}

# scrape_data_ls(url = url_ge_1_16$url[2],pass_ge = 15) #test


map2_dfr(.x = as.list(url_ge_1_16$url[1:4]),
         .y = as.list(url_ge_1_16$ls_ge[1:4]),
         .f = scrape_data_ls) -> data_ge_state_seats

data_ge_state_seats %>% 
  filter(!str_detect(srn,"S")) %>% 
  mutate(
    across(.cols = c(srn,n_seats,ge),.fns = as.numeric)
  )   -> data_ge_state_seats


scrape_data_ls_single_table <- function(url,pass_ge){
  
  read_html(url) %>% 
    html_element(".member_list_table") %>% 
    html_table(header = T,trim = T) -> tab_list 
  
  colnames(tab_list) <- c("srn","states","n_seats")
  
  
  tab_list %>% 
    mutate(
      ge = pass_ge
    )
  
  
}

map2_dfr(.x = as.list(url_ge_1_16$url[5:16]),
         .y = as.list(url_ge_1_16$ls_ge[5:16]),
         .f = scrape_data_ls_single_table) -> data_ge_state_seats_single

rbind(data_ge_state_seats,data_ge_state_seats_single) -> data_seats_ge


# prep and clean ----------------------------------------------------------

data_seats_ge %>% 
  mutate(
    year_ge = case_when(
      ge == 16 ~ 2014,
      ge == 15 ~ 2009,
      ge == 14 ~ 2004,
      ge == 13 ~ 1999,
      ge == 12 ~ 1998,
      ge == 11 ~ 1996,
      ge == 10 ~ 1991,
      ge == 9 ~ 1989,
      ge == 8 ~ 1984,
      ge == 7 ~ 1980,
      ge == 6 ~ 1977,
      ge == 5 ~ 1971,
      ge == 4 ~ 1967,
      ge == 3 ~ 1962,
      ge == 2 ~ 1957,
      ge == 1 ~ 1952 
    )
  ) %>% 
  select(-srn) %>% 
  write_csv("data/2_data_contituencies_seats.csv")

