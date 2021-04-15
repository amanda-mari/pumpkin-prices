# Change date column from character to date

 character_to_date <- function(dataset) {
    date_numeric <- as.Date(as.character(dataset$date), format = "%m/%d/%Y")
    cbind(dataset, date_numeric)
  }


find_and_order_dates <- function(dataset) {
     all_dates <- dataset[order(dataset$date_numeric),"date_numeric"]
     unique(all_dates)
}

find_missing_dates <- function(dataset, all_dates){
         missing_dates <- which(!all_dates %in% dataset$date_numeric)
         all_dates[missing_dates]
       }


find_unique_column_values <- function(dataset, col) {
    unique(dataset$col)
  }

make_text_lowercase <- function(dataset, col) {
              dataset$col <- tolower(dataset$col)
}

