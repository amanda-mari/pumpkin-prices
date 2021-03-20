# Load packages
library('tidyverse')
library('data.table')
library('here')

# Read in all csv files as a list

city_files <-list.files(path = here::here("data/raw"), 
                        pattern = "*.csv", 
                        full.names = TRUE)

pumpkin_data <-lapply(city_files, data.table::fread, sep = ",")


# Rename list elements so that the original file source can be identified

pumpkin_data <- setNames(pumpkin_data,
                         str_extract(city_files, "(?<=raw/).*?(?=_\\d)"))


# Rename columns
old_column_names <- c("Commodity Name", "City Name",
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

new_column_names <-c("commodity_name", "city_name",
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
                     "crop", "repack","trans_mode",
                     "offerings", "market_tone",
                     "price_comment", "comments"
                     )

pumpkin_data <-lapply(pumpkin_data, 
                      data.table::setnames,
                      skip_absent = TRUE,
                      old_column_names,
                      new_column_names)

rm(city_files, old_column_names, new_column_names)

# Verify that data types are correct
  
glimpse(pumpkin_data)


# use str() and summary()

lapply(pumpkin_data, 
       summary)
# check for missing values and unique()