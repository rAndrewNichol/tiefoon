# functions to be sourced to code/scripts/clean-data-script.R

library(stringr)

# Standard function to convert format ` ft-in ` simply to a value of inches.
convert_ft_inches <- function(height = NULL){
  ft <- as.numeric(str_extract(height, "^[0-9]+"))
  inches <- as.numeric(str_extract(height, "[0-9]+$"))
  return(ft*12 + inches)
}

# Format dates using the as.Data() function.
format_dates <- function(date = NULL){
  as.Date(date, format = "%B %d, %Y")
}

# Removes the non-numeric values from a string. In this case, this function
# is used to remove the '$' and ','s from a string of the format "$n,nnn,nnn".
remove_non_numeric <- function(salary = NULL){
  new_salaries <- as.numeric(str_replace_all(salary, "[^0-9]", ""))
  return(new_salaries)
}