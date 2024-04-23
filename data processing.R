library(tidyverse)
library(janitor)

IPR <- read_csv('School_Neighborhood_Poverty_Estimates%2C_2018-19.csv') |> 
  select(c(NAME, IPR_EST, IPR_SE, NCESSCH)) |> 
  clean_names() |> 
  rename(school_name = name)

#† means not applicable, – means missing, ‡ means the value doesn't meet data quality standards.
Schools <- read_csv('Schools.csv', na = c('†', '–', '‡'), trim_ws = TRUE) |> 
  clean_names() |> 
  select(!c(school_n, state_name, state_abbr))
#Get School IDS to match with IPR
SchoolIDS <- read_csv('SchoolIDS.csv', na = c('†', '–', '‡'), trim_ws = TRUE) |> 
  clean_names() |> 
  select(!c(school_n, state_name))
#Join IDS with Schools dataframe to join with IPR estimates
Schools <- inner_join(Schools, SchoolIDS, by = c('school_name', 'agency_name'))

Counties <- read_csv('Counties.csv', na = c('†', '–', '‡'), trim_ws = TRUE) |> 
  clean_names() |> 
  select(!c(state_name_district_latest_available_year, state_abbr_district_latest_available_year))

#Join IPR to schools and get rid of duplicate name column
Schools <- inner_join(IPR, Schools, by = 'ncessch') |> 
  select(!c(school_name.y, ncessch)) |> 
  rename(school_name = school_name.x)
