---
title: "README"
output: html_document
---

# NBA Player Evaluation 2015-2016

  This project involves the evaluation of NBA players. Specifically, it attempts to answer the motivating question, *"In the 2015-2016 season, how do the skills of a player relate to his salary?"*. After the data was cleaned and exploratory data analysis was performed, an efficiency value was calculated for all players. Finally, two interactive shiny apps were produced to provide a platform for interactive data analysis.

## Datasets 

  The primary source of data for this project is: [Basketball Reference](http://www.basketball-reference.com/) (by *Sports Reference LLC*) which provides statistics, scores, and history for the NBA, ABA, WNBA, and top European competition.
  The data used for this project comes from the 2015-2016 season and can be found in the Roster, Totals (player stats), and Salary tables from each team's webpage (ex. http://www.basketball-reference.com/teams/CLE/2016.html ).
<!--  
  The different variables analyzed are as follows: 
- `team` (teams of the players)  
- `name` (names of the players)  
- `salary` (salaries of the players)  
- `position` (the positions played by the players)  
- `age` (the ages of the players)  
- `height` (the height of the players in inches)  
- `weight` (the weight of the players in pounds)  
- `dob` (the birthdates of the players)  
- `country` (the countries of origin of the players)  
- `experience` (the number of seasons the players have played)  
- `college` (the college the players played for)  
- `games` (the number of games the players have played)  
- `games_started` (the number of games the players have started)  
- `minutes_played` (the number of minutes the players have played)  
- `field_goals` (the number of field_goals made by the players)  
- `field_goals_attempts` (the number of field_goals attempted by the players)  
- `field_goals_pct` (the field_goals percentage of the players)  
- `three_pointers` (the number of three pointers made by the players)  
- `three_pointers_attempts` (the number of three pointers attempted by the players)  
- `three_pointers_pct` (the three point percentage of the players)  
- `two_pointers` (the number of two pointers made by the players)  
- `two_pointers_attempts` (the number of two pointers attempted by the players)  
- `two_pointers_pct` (the two point percentage of the players)  
- `effective_field_goal_pct` (the field goal percentage of the players)  
- `free_throws` (the number of free throws made by the players)  
- `free_throws_attempts` (the number of free throws attempted by the players)  
- `free_throws_pct` (the free throw percentage of the players)  
- `offensive_rebounds` (the number of offensive rebounds made by the players)  
- `defensive_rebounds` (the number of defensive rebounds made by the players)  
- `total_rebounds` (the number of total rebounds made by the players)  
- `assists` (the number of assists made by the players)  
- `steals` (the number of steals made by the players)  
- `blocks` (the number of blocks made by the players)  
- `turnovers` (the number of turnovers made by the players)  
- `personal_fouls` (the number of personal_fouls given to each players)  
- `points` (the number of points earned by the players)  
- `outlier` (whether a player data was duplicated, i.e. traded midseason)  
-->

## Methodology 

  First, the data had to be cleaned. It was sourced from 30 teams, three tables of data for each, which resulted in cleaning 90 files. Iterative loops were employed to scrape from each team's url using XML. After further cleaning, including re-formatting, unit conversions, deduplicating data, and outlier cleaning, the data was written to a single csv file.
  
  As part of data analysis, salary statistics were aggregated by team. Basic summary statistics can be found in *data/cleandata/eda-output.txt*. These statistics can also be interactively viewed using the shiny app at https://randrewnichol.shinyapps.io/team-salaries/ to discern trends, variance among and between teams, and outliers. 
  
  Next, to represent the performance of NBA players, a holistic efficiency statistic was calculated with player position accounted for using a Principle Component Analysis. The modified EFF formula takes the weights from the PCA analysis, multiplies them by the variables in the original EFF formula, and divides that result by the standard deviation found from the PCA analysis. There is a shiny app available at https://randrewnichol.shinyapps.io/stat-salaries/ that plots different skills and salary and overall efficiency against each other. 
  
  When it came to analyzing the value of the player, a simple ratio is considered in which value was given by the modified efficiency divided by salary. This is a simple way to quantify the most and least valuable players, which was aggregated into a list of the 20 best and 20 worst players(excluding outliers) which can be found at *data/cleandata/player_value_rankings.txt*.

## Structure of project files

project/ (where all of the files are stored)  
  &nbsp;&nbsp;&nbsp;README.md (the README providing an overview of the project)  
  &nbsp;&nbsp;&nbsp;code/ (where all of the code in the project is stored)  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;functions/ (where the functions are stored)  
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;scripts/ (the scripts used for the data analysis, described by their titles)  
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;download-data-script.R    
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;clean-data-script.R   
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eda-script.R   
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;compute-efficiency-script.R  
  &nbsp;&nbsp;&nbsp;data/ (where the downloaded data files are stored)  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rawdata/ (uncleaned data)  
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;roster-data/ (the roster data for the players)  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...   
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;salary-data/ (the player salaries)  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...   
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stat-data/ (the player stats)  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...   
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cleandata/ (where the data is stored after it is cleaned)  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;roster-salary-stats.csv (final cleaned pre-analysis dataset)  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eff-stats-salary.csv (efficiency calculation stats)  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eda-output.txt (output of the exploratory data analysis)  
  &nbsp;&nbsp;&nbsp;images/ (where the images are stored)  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...   
  &nbsp;&nbsp;&nbsp;apps/ (where the shiny app implementations are stored)  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;team-salaries/ (visualizes team statistics)  
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ui.R   
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;server.R  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;stat-salaries/ (visualizes player stats to salary relationship)  
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ui.R   
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;server.R   
  &nbsp;&nbsp;&nbsp;report/ (where the written report is stored)  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;report.Rmd   
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;report.pdf   
  &nbsp;&nbsp;&nbsp;slides/ (where the slides are stored)  
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;slides.pdf  
    
## Utilized

* [R statistics platform](https://www.r-project.org/) - The statistical platform used to code
* [Open Science Framework](https://osf.io/) - Online data repository used
* [Shiny](https://shiny.rstudio.com/) - Web application framework for R
* [Stringr](https://cran.r-project.org/web/packages/stringr/index.html) - Package for R for regular expression operations
* [XML](https://cran.r-project.org/web/packages/XML/index.html) - Package for R for parsing XML and HTML documents and tables
* [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) - Package for R for dataframe manipulation
* [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) - Package for R for creating more complex graphics than base R

## Authors

R ANDREW NICHOL

## License

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

## Acknowledgments

I acknowledge Gaston Sanchez and the GSI and TAs of the Stat 133 class for the project inspiration. I also acknowledge *Sports Reference LLC* for providing the data that made this project possible. Finally, I acknowledge the R and Rstudio developers for the platforms on which I performed this project. 
