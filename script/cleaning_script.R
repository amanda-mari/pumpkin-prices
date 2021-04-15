# Load packages ---------------------------
library("tidyverse")
library("data.table")
library("here")

# Functions ---------------------------
source("script/functions_script.R")

# Read in all csv files as a list ---------------------------

city_files <- list.files(
  path = here::here("data/raw"),
  pattern = "*.csv",
  full.names = TRUE
)

pumpkin_data <- lapply(city_files, data.table::fread, sep = ",")


# Rename list elements so that the original file source can be identified ---------------------------

pumpkin_data <- setNames(
  pumpkin_data,
  str_extract(city_files, "(?<=raw/).*?(?=_\\d)")
)


# Rename columns ---------------------------
old_column_names <- c(
  "Commodity Name", "City Name",
  "Type", "Package",
  "Variety", "Sub Variety",
  "Grade", "Date",
  "Low Price", "High Price",
  "Mostly Low", "Mostly High",
  "Origin", "Origin District",
  "Item Size", "Color",
  "Environment", "Unit of Sale",
  "Quality", "Condition",
  "Appearance", "Storage",
  "Crop", "Repack",
  "Trans Mode",
  # the following 4 columns only appear in the St. Louis file
  "Offerings",
  "Market Tone",
  "Price Comment",
  "Comments"
)

new_column_names <- c(
  "commodity_name", "city_name",
  "type", "package",
  "variety", "sub_variety",
  "grade", "date",
  "low_price", "high_price",
  "mostly_low", "mostly_high",
  "origin", "origin_district",
  "item_size", "color",
  "environment", "unit_of_sale",
  "quality", "condition",
  "appearance", "storage",
  "crop", "repack", "trans_mode",
  "offerings", "market_tone",
  "price_comment", "comments"
)

pumpkin_data <- lapply(pumpkin_data,
  data.table::setnames,
  skip_absent = TRUE,
  old_column_names,
  new_column_names
)

rm(city_files, old_column_names)

# Check variable types and data summary ---------------------------

glimpse(pumpkin_data)


lapply(
  pumpkin_data,
  summary
)
# Check unique values in each column before changing column types ---------------------------

lapply(
  pumpkin_data,
  function(dataset) {
    apply(dataset, 2, unique)
  }
)


# Change date column from character to date ---------------------------
pumpkin_data <- lapply(
  pumpkin_data,
  character_to_date
)

# Find and order all the unique dates in each city ---------------------------
lapply(
  pumpkin_data,
  find_and_order_dates
)

# Create a vector of weekdays to check against dates in each city's data ---------------------------
# This data is supposed to span 09/24/2016 to 09/30/2017 weekly, 54 days total

all_dates <- seq.Date(
  from = as.Date("2016/09/24"),
  to = as.Date("2017/09/30"),
  by = 7
)

lapply(pumpkin_data,
  find_missing_dates,
  all_dates = all_dates
)



# Atlanta has data for 11 dates; missing data from 11/27/2016 to 09/29/2017
# Baltimore has data for 23 dates; missing data from 11/27/2016 to
# 05/07/2017,  06/02/2017 to 06/18/2017 to 08/11/2017
# Boston has 17 unique dates; missing data from 12/11/2016 to 09/01/2017
# Chicago has 51 dates; missing data from 12/11/2016 to 01/06/2017
# Columbia has 12 dates; missing data from 11/06/2016 to 09/01/2017
# Dallas has 11 dates; missing data from 11/13/2016 to 09/15/2017
# Detroit has 11 dates; missing data from 11/06/2016 to 09/08/2017
# Los Angeles has 14 dates; missing data from 11/06/2016 to 08/18/2016
# Miami only has 1 date and it is in 2014
# New York has 11 dates; missing data from 11/06/2016 to 09/08/2017
# Philadelphia has 11 dates; missing data from 11/06/2016 to 08/25/2017
# and 08/27/2017 to 05/15/2017
# San Francisco has 19 dates; missing data from 12/11/2016 to 01/06/2017
# and 01/15/2017 to 09/01/2017
# St Louis data only has 5 dates and they are all in 09/2016

rm(all_dates)


#to do list 

# check for missing values and unique values in each column,
# change any blanks to NA and clean text responses
# visualize individual variable distributions and 2 var plots
