# Exploratory Data Analysis Script

# Gather summary statistics for all variables and sink() them to a txt file
# (data/cleandata/eda-output.txt)
# Create a dataframe for all salary statistics and write to a csv to be 
# implemented into our interactive shiny app.

library(ggplot2)
library(dplyr)

# ==============================================================================

df <- read.csv(file = "data/cleandata/roster-salary-stats.csv",
               stringsAsFactors = F)

relevant_variables = c("salary", "age", "height", "weight", "experience",
                       "games", "games_started", "minutes_played", 
                       "field_goals", "field_goal_attempts", "three_pointers",
                       "three_point_attempts", "two_pointers", 
                       "two_point_attempts", "free_throws", 
                       "free_throw_attempts", "offensive_rebounds", 
                       "defensive_rebounds", "total_rebounds", "assists", 
                       "steals", "blocks", "turnovers", "personal_fouls", 
                       "points")

sink(file = "data/cleandata/eda-output.txt",
     split = T,
     append = F,
     type = "output")

# Iterate through each variable, calculate summary statistics, and print them
# (to our sinked file)
for(each_parameter in relevant_variables){
  cat("=============================================================\n")
  
  cat(each_parameter, ':\n\n' , sep = "")
  
  print(summary(df[ , each_parameter]))

  cat("\nRange:",range(df[ , 
      each_parameter])[2] - range(df[ , each_parameter])[1],
      "\n","\n")

  cat("Standard Deviation:", sd(df[ , each_parameter]), '\n')

}

sink()

# Gather variable names using colnames() and exclude the first column (rownames)
columns <- colnames(df)[2:ncol(df)]

# ==============================================================================
# Histograms. Plot only those variables of integer class. There is no need
# to print ratio or nominal variables. 
for (x in columns){
  if (class(df[1,x]) == 'integer'){
    ggplot(data = df, aes(df[ ,x])) + 
      geom_histogram() + ggtitle(x) + xlab(x)
    ggsave(filename = paste0("images/histogram_",x,".png"))
  }
}

# Salary, height, and weight are seperated out for special units

ggplot(data = df, aes(df$salary)) + 
  geom_histogram() + ggtitle("salary") + xlab("USD")
ggsave(filename = paste("images/histogram_salary.png"))

ggplot(data = df, aes(df$height)) + 
  geom_histogram() + ggtitle("height") + xlab("inches")
ggsave(filename = paste("images/histogram_height.png"))

ggplot(data = df, aes(df$weight)) + 
  geom_histogram() + ggtitle("weight") + xlab("pounds")
ggsave(filename = paste("images/histogram_weight.png"))

# ==============================================================================
# Boxplots
for (x in columns){
  if (class(df[1,x]) == 'integer'){
    
    qplot(y = df[ ,x], x = 1, geom = "boxplot", xlab = x, ylab = x) +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank()) + ggtitle(x)
    ggsave(filename = paste0("images/boxplot_",x,".png"))
  }
}

qplot(y = df$salary, x = 1, geom = "boxplot", xlab = "salary", ylab = "USD") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) + ggtitle("salary")
ggsave(filename = paste("images/boxplot_salary.png"))

qplot(y = df$weight, x = 1, geom = "boxplot", xlab = "weight", ylab = "pounds")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) + ggtitle("weight")
ggsave(filename = paste("images/boxplot_weight.png"))

qplot(y = df$height, x = 1, geom = "boxplot", xlab = "height", ylab = "inches")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) + ggtitle("height")
ggsave(filename = paste("images/boxplot_height.png"))

# ==============================================================================
# Barplots, players as x axis, the count/special unit as y axis

for (x in columns){
  if (class(df[1,x]) == 'integer'){
    ggplot(data = df, aes(df$name, df[ ,x])) + 
      geom_bar(stat = "identity") + ggtitle(x) + xlab("Players") + ylab(x) +
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank())
    ggsave(filename = paste0("images/barplot_",x,".png"))
  }
}

ggplot(data = df, aes(df$name, df$salary)) + 
  geom_bar(stat = "identity") + 
  ggtitle("salary") + xlab("Players") + ylab("USD") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

ggsave(filename = paste("images/barplot_salary.png"))

ggplot(data = df, aes(df$name, df$salary)) + 
  geom_bar(stat = "identity") + 
  ggtitle("height") + xlab("Players") + ylab("inches") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

ggsave(filename = paste("images/barplot_height.png"))

ggplot(data = df, aes(df$name, df$salary)) + 
  geom_bar(stat = "identity") + 
  ggtitle("weight") + xlab("Players") + ylab("pounds") +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank())

ggsave(filename = paste("images/barplot_weight.png"))

# ==============================================================================
# Get team salary summaries

df_salaries <- df[ , c("salary", "team")]

# Gather a vector of each team name only once using dplyr::distinct()
team_names <- distinct(df, team)

df_salary_stats <- data.frame(NULL)

for(each_name in team_names$team){
  temp_df <- filter(df_salaries, team == each_name)
  new_row <- data.frame(team = each_name,
                        total_payroll = sum(temp_df$salary),
                        minimum = min(temp_df$salary),
                        maximum = max(temp_df$salary),
                        first_quartile = round(quantile(temp_df$salary, 
                                                        .25,
                                                        names = FALSE),
                                               digits=0),
                        median = median(temp_df$salary),
                        third_quartile = quantile(temp_df$salary, .75,
                                                  names = FALSE),
                        average = mean(temp_df$salary),
                        iqr = IQR(temp_df$salary),
                        std_dev = sd(temp_df$salary),
                        stringsAsFactors = FALSE
                        )
  df_salary_stats <- rbind(df_salary_stats, new_row)
}

# Found at http://teamcolorcodes.com/category/nba-team-color-codes/
# will be used for the plots in the shiny app team-salaries
df_salary_stats$color<- c("#CE1141", "#007DC5", "#1D1160", "#005083", "#E03A3E",
                          "#E13A3E", "#002B5C", "#E56020", "#002B5C", "#ED174C",
                          "#002B5C", "#98002E", "#008348", "#860038", "#006BB6",
                          "#FDB927", "#BAC3C9", "#007DC3", "#061922", "#CE1141",
                          "#CE1141", "#552582", "#F58426", "#4D90CD", "#724C9F",
                          "#0F586C", "#FFC633", "#006BB6", "#007DC5", "#00471B")

write.csv(df_salary_stats, row.names = FALSE,
          file = "data/cleandata/team-salaries.csv")

# eof