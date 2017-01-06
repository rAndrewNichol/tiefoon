# Cleans and organizes the data for easy dataframe manipulation and data
# analysis. Cleans dataframes for "roster", "stats", and "salary" tables
# and combines them into a final dataframe which is written to 
# data/cleandata/roster-salary-stats.csv

source("code/functions/cleaning-functions.R")

library(XML)
library(dplyr)

#==============================================================================

# Base url
basketref <- 'http://www.basketball-reference.com'

# Parse 'http://www.basketball-reference.com/leagues/NBA_2016.html'
url <- paste0(basketref, '/leagues/NBA_2016.html')
page <- htmlParse(url)

# Identify nodes with anchor tags for each team and
# extract the href attribute from the anchor tags
team_rows <- getNodeSet(page, "//th[@scope='row']/a")
team_urls <- xmlSApply(team_rows, xmlAttrs)

# Remove duplicates
team_urls_unique <- unique(team_urls)

# Just in case, here's the character vector with the team abbreviations
team_names <- substr(team_urls_unique, 8, 10)

#==============================================================================

#==============================================================================
# Roster Data Cleaning
#==============================================================================

# Create a dataframe of every roster
df_roster = read.csv(file = paste0("data/rawdata/roster-data/roster-", 
                            team_names[1], ".csv"), 
                            stringsAsFactors = F)

for(i in 2:30){
  df_roster <- rbind(df_roster,
                     read.csv(file = paste0("data/rawdata/roster-data/roster-", 
                              team_names[i], ".csv"), 
                              stringsAsFactors = F))
}

# get rid of useless first column
df_roster <- df_roster[,2:ncol(df_roster)]

roster_names = c("number","name","position","height",
                 "weight","dob","country",
                 "experience","college","team")

names(df_roster) = roster_names

# reformat heights to standardized inches for ease of quantitative manipulation.
df_roster$height <- convert_ft_inches(df_roster$height)

# change to standard R date format
df_roster$dob <- format_dates(df_roster$dob)

#==============================================================================
# Stats Data Cleaning
#==============================================================================

df_stats = read.csv(file = paste0("data/rawdata/stat-data/stats-", 
                            team_names[1], ".csv"), 
              stringsAsFactors = F)

for(i in 2:30){
  df_stats <- rbind(df_stats,
                    read.csv(file = paste0("data/rawdata/stat-data/stats-", 
                             team_names[i], ".csv"), 
                             stringsAsFactors = F))
}

#get rid of first and second columns that mean nothing.
df_stats <- df_stats[,3:ncol(df_stats)]

stats_names = c("name", "age", "games", "games_started", "minutes_played",
                "field_goals", "field_goal_attempts", "field_goal_pct", 
                "three_pointers", "three_point_attempts", "three_point_pct", 
                "two_pointers", "two_point_attempts", "two_point_pct", 
                "effective_field_goal_pct", "free_throws", "free_throw_attempts", 
                "free_throw_pct", "offensive_rebounds", "defensive_rebounds", 
                "total_rebounds", "assists", "steals", "blocks", "turnovers", 
                "personal_fouls", "points")

names(df_stats) = stats_names

#==============================================================================
# salary Data Cleaning
#==============================================================================

df_salaries = read.csv(file = paste0("data/rawdata/salary-data/salaries-", 
                                  team_names[1], ".csv"), 
                    stringsAsFactors = F)

for(i in 2:30){
  df_salaries <- rbind(df_salaries,
                    read.csv(file = paste0("data/rawdata/salary-data/salaries-", 
                                           team_names[i], ".csv"), 
                             stringsAsFactors = F))
}

# Get rid of first two pointless columns
df_salaries <- df_salaries[, 3:ncol(df_salaries)]

names(df_salaries) = c("name", "salary") 

# Remove the dollar signs ($) and commas from salary values for ease of 
# data manipulation and analysis
df_salaries$salary <- remove_non_numeric(df_salaries$salary)


#===================
# Combine:

player_names <- distinct(df_roster, name)[[1]]

df_salaries_temp <- data.frame(NULL) 

# Get distinct entries, sum salaries, and add a column of booleans
# which indicate that the player is an outlier as his data came
# from multiple teams.
for(x in player_names){
  temp_df <- filter(df_salaries, name == x)
  if(nrow(temp_df) > 1){
    new_rows <- data.frame(name = temp_df$name[1], 
                          salary = sum(temp_df$salary),
                          outlier = TRUE,
                          stringsAsFactors = FALSE)
  } else if(nrow(temp_df)==1){
    outlier_col <- data.frame(outlier = FALSE)
    new_rows <- cbind(temp_df, outlier_col)
  }
  df_salaries_temp <- rbind(df_salaries_temp, new_rows)
}

# Get only distinct entries
df_roster <- distinct(df_roster, name, .keep_all = T)
df_stats <- distinct(df_stats, name, .keep_all = T)

# Sort them
df_roster <- df_roster[order(df_roster$name),]
df_stats <- df_stats[order(df_stats$name),]
df_salaries <- df_salaries_temp[order(df_salaries_temp$name),]

# Clear extra dataframes from memory
rm(df_salaries_temp, new_rows, outlier_col, temp_df)

# Combine them (now that they are all sorted, it is only necessary to combine
# them directly)
combined <- data.frame(df_roster[ , 2:ncol(df_roster)],
                 df_stats[ , 2:ncol(df_stats)],
                 df_salaries[, -1],
                 stringsAsFactors = F,
                 row.names=NULL)

# Remove any positions other than the main five.
combined <- filter(combined, position == "C" | position == "PF" | position == "SF" |
       position == "SG" | position == "PG")
# There did not end up being any positions other than these.

# Reorder dataframe (just organizing)
combined <- combined[ , c(9,1,36,2,10,3:8,11:35,37)]

# Change 'R's in experience to 0's. (easier to read and just in case
# there are problems during data analysis)
combined$experience <- replace(combined$experience, 
                               list = grep("R",combined$experience), 
                               values= 0)

# Write final dataframe to a csv
write.csv(combined,
          file = "data/cleandata/roster-salary-stats.csv",
          row.names = FALSE)
