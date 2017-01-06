# Download and Parse data by iterating through each team's url on 
# the basketball reference website.
# Employs functions from scraping-function.R and the XML package.

source("code/functions/scraping-functions.R")

library(XML)

#==============================================================================

# base url
basketref <- 'http://www.basketball-reference.com'

# parse 'http://www.basketball-reference.com/leagues/NBA_2016.html'
url <- paste0(basketref, '/leagues/NBA_2016.html')
page <- htmlParse(url)

# identify nodes with anchor tags for each team and
# extract the href attribute from the anchor tags
team_rows <- getNodeSet(page, "//th[@scope='row']/a")
team_urls <- xmlSApply(team_rows, xmlAttrs)

# remove duplicates
team_urls_unique <- unique(team_urls)

# just in case, here's the character vector with the team abbreviations
team_names <- substr(team_urls_unique, 8, 10)

#==============================================================================

# Iterate through each team's URL and scrape each of the three tables.
for(i in 1:30){
  # Read html document (as a character vector) for each team
  url_team <- paste0(basketref, team_urls[i])
  html_doc <- readLines(con = url_team)
  # Call our sourced functions to extract each table
  scrape_roster(doc = html_doc, team_abbrev = team_names[i])
  scrape_totals(doc = html_doc, team_abbrev = team_names[i])
  scrape_salaries(doc = html_doc, team_abbrev = team_names[i])
}
