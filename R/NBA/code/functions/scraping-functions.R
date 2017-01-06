# functions to be sourced to code/scripts/download-data-script.R

# ==============================================================================
# Function to scrape the roster table of each team and write to a csv.
# Expected input is a document (vector of strings representing a webpage source
# code). There is no output, but the function does write the desired dataframe
# to a csv.

scrape_roster <- function(doc = NULL, team_abbrev = NULL){
  
  # initial line position of roster html table
  begin_roster <- grep('id="roster"', doc)

  # find the line where the html ends
  line_counter <- begin_roster
  
  # "</table>" is the closing tag for a table
  while (!grepl("</table>", doc[line_counter])) {
    line_counter <- line_counter + 1
  }
  
  # read roster table as data.frame and export it as csv
  roster <- readHTMLTable(doc[begin_roster:line_counter])
  roster$Team <- team_abbrev
  write.csv(roster, 
            file = paste0('data/rawdata/roster-data/roster-', 
                          team_abbrev, '.csv'))
}

# ==============================================================================
# Function to scrape player stats. Analogous to previous function but for
# the totals table.

scrape_totals <- function(doc = NULL, team_abbrev = NULL){
  
  # initial line position of totals html table
  begin_totals <- grep('id="totals"', doc)
  
  # find the line where the html ends
  line_counter <- begin_totals
  while (!grepl("</table>", doc[line_counter])) {
    line_counter <- line_counter + 1
  }
  
  # read totals table as data.frame and export it as csv
  totals <- readHTMLTable(doc[begin_totals:line_counter])
  write.csv(totals, 
            file = paste0('data/rawdata/stat-data/stats-', 
                          team_abbrev, '.csv'))
}

# ==============================================================================
# Function to scrape player salaries. Analogous to previous functions but for
# the salary table.

scrape_salaries <- function(doc = NULL, team_abbrev = NULL){
  
  # initial line position of salaries html table
  begin_salaries <- grep('id="salaries"', doc)
  
  # find the line where the html ends
  line_counter <- begin_salaries
  while (!grepl("</table>", doc[line_counter])) {
    line_counter <- line_counter + 1
  }
  
  # read salaries table as data.frame and export it as csv
  salaries <- readHTMLTable(doc[begin_salaries:line_counter])
  write.csv(salaries, 
            file = paste0('data/rawdata/salary-data/salaries-', 
                          team_abbrev, '.csv'))
}