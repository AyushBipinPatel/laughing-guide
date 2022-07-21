#### This script contains code to clean data and structure it appropriately 
#### for required analysis/simulations


# libraries ---------------------------------------------------------------

library(here)
library(tidyverse)

# Cleaning the file 1_data_tcps_general_elections.csv, can be found -->here::here("data/1_data_tcps_general_elections.csv")-------------------------------------------------------


#### This file has data from the 1962 general election(GE) up-to 2019 GE
#### All observations are at candidate level, we required data at constituency level


#### Loading the data

data_tcpd_ge_62_19 <- read_csv(
  here("data/1_data_tcps_general_elections.csv")
)

#### Keeping relevant columns

    # We do not require all the details in the data, we will
    # keep those columns that are useful in creating constituency
    # level data. We are only interested in scheduled GE, not bye-elections. 
    # Therefore all by-elections years are changed to respective GE years 
    # to arrive at exhaustive list of constituencies in a given year. Meaning,
    # all bye-election for the GE 1962 are considered to be in 1952 so that
    # a exhaustive list of constituencies is available for that Year.
    # In cases where the number of electors have changed in the bye-election year,
    # number of electors of that constituency is taken as that number in the year of GE.

data_tcpd_ge_62_19 %>% 
  filter(Position == 1) %>% 
  filter(Poll_No == 0) %>%  
  filter(Year != 1992) %>% 
  select(State_Name,
         Year,Electors,Constituency_Name,
         Constituency_Type, DelimID) %>% 
  
  distinct() %>% 
  mutate(
    Year = ifelse(Year == 1985,1984,Year),
    temp1 = str_c(Year,State_Name,Constituency_Name)
  ) %>%
  write_csv("data/4_data_constituency_level_ge_year_electors.csv")
  # group_by(Year) %>% 
  # summarise(
  #   states = length(unique(State_Name)),
  #   seats =n()
  # ) %>% 
  # write_csv("data/3_data_ge_year_states_seats.csv")


# Clean pop age sub grp estimate data -------------------------------------


readxl::read_xlsx("data/6_data_India_5yr_age_sex_2000-2020_508_uscb_aug2016.xlsx",
                  skip = 3,sheet = "sheet_read") %>% 
  filter(ADM_LEVEL == 1) %>% 
  select(ADM1_NAME, ADM_LEVEL,COMMENT,contains("B")) %>% 
  write_csv("data/7_data_age_grp_pop_est_2000_to_2020.csv")
