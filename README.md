# laughing-guide
Delimitations in India | Over/Under representation of states in Lok sabha


This repo contains files to understand the representation of states in the Lok Sabha. 

This work is carried out with Shruti Rajagopalan, Kadambari Shah and Maxwell Tabarrok.

## The data

All the data is in the `data` folder.

  + The file `1_data_tcps_general_elections.csv` is from the [data portal of TCPD](https://lokdhaba.ashoka.edu.in/browse-data?et=GE&st=all&an=all). This contains Candidates at constituency level general election results starting from 1962 (3rd GE) to 2019 (17th GE). Code book for this data can be found [here](https://lokdhaba.ashoka.edu.in/static/media/2022Feb12LokDhabaCodebook.21040cf7.pdf). This code book is developed by the TCPD.
  
## R code for cleaning and structuring data

The file(s) in the folder `data_cleaning` are scripts to clean and structure the data in the desirable format. The clean and structured data is stored in the folder `data`.

  + The file `clean_and_structure.R` is used to clean and structure the data.