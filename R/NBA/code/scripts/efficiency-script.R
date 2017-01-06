# EFF and Value of Players Script

# Calculating efficiency rating for players based on a principal components
# analysis using the function prcomp()
# Calculating players' values by finding the ratio of their efficiency rating
# and their salary.

library(dplyr)

# ==============================================================================

data = read.csv('data/cleandata/roster-salary-stats.csv',
                stringsAsFactors = FALSE)

# Subset data for position 'PG' (point guard)
# and add Missed Field Goals MFG, Missed Free Throws MFT, Turnovers TO
# (these variables have negative sign)
pg <- data %>%
  filter(position == 'PG') %>%
  mutate(MFT = (-1)*(free_throw_attempts - free_throws)) %>%
  mutate(MFG = (-1)*(field_goal_attempts - field_goals)) %>%
  mutate(TO = -1 * turnovers)

# head(pg)

# Statistics for efficiency
stats <- c('points', 'total_rebounds', 'assists', 'steals',
           'blocks', 'MFT', 'MFG', 'TO')

# All variables are divided by number of games
X <- as.matrix(pg[ ,stats] / pg$games)
# print(round(cor(X), 2), print.gap = 2)

# PCA with prcomp()
pg_pca <- prcomp(X, center = TRUE, scale. = TRUE)
pg_weights <- pg_pca$rotation[,1]

if (sum(sign(pg_weights)) < 0) {
  pg_weights = -1 * pg_weights
}

# Standard deviations
pg_sigmas <- apply(X, 2, sd)

# Modified efficiency
pg_eff <- X %*% (pg_weights / pg_sigmas)
pg$EFF <- pg_eff

# Subset data for position 'PF' (power forward)
# and add Missed Field Goals MFG, Missed Free Throws MFT, Turnovers TO
# (these variables have negative sign)
pf <- data %>%
  filter(position == 'PF') %>%
  mutate(MFT = (-1)*(free_throw_attempts - free_throws)) %>%
  mutate(MFG = (-1)*(field_goal_attempts - field_goals)) %>%
  mutate(TO = -1 * turnovers)

# head(pf)

# All variables are divided by number of games
Y <- as.matrix(pf[ ,stats] / pf$games)
# print(round(cor(Y), 2), print.gap = 2)

# PCA with prcomp()
pf_pca <- prcomp(Y, center = TRUE, scale. = TRUE)
pf_weights <- pf_pca$rotation[,1]

if (sum(sign(pf_weights)) < 0) {
  pf_weights = -1 * pf_weights
}

# Standard deviations
pf_sigmas <- apply(Y, 2, sd)

# Modified efficiency
pf_eff <- Y %*% (pf_weights / pf_sigmas)
pf$EFF <- pf_eff

# Subset data for position 'C' (center)
# and add Missed Field Goals MFG, Missed Free Throws MFT, Turnovers TO
# (these variables have negative sign)
c <- data %>%
  filter(position == 'C') %>%
  mutate(MFT = (-1)*(free_throw_attempts - free_throws)) %>%
  mutate(MFG = (-1)*(field_goal_attempts - field_goals)) %>%
  mutate(TO = -1 * turnovers)

# head(c)

# All variables are divided by number of games
Z <- as.matrix(c[ ,stats] / c$games)
# print(round(cor(Z), 2), print.gap = 2)

# PCA with prcomp()
c_pca <- prcomp(Z, center = TRUE, scale. = TRUE)
c_weights <- c_pca$rotation[,1]

if (sum(sign(c_weights)) < 0) {
  c_weights = -1 * c_weights
}

# Standard deviations
c_sigmas <- apply(Z, 2, sd)

# Modified efficiency
c_eff <- Z %*% (c_weights / c_sigmas)
c$EFF <- c_eff

# Subset data for position 'SG' (shooting guard)
# and add Missed Field Goals MFG, Missed Free Throws MFT, Turnovers TO
# (these variables have negative sign)
sg <- data %>%
  filter(position == 'SG') %>%
  mutate(MFT = (-1)*(free_throw_attempts - free_throws)) %>%
  mutate(MFG = (-1)*(field_goal_attempts - field_goals)) %>%
  mutate(TO = -1 * turnovers)

# head(sg)

# All variables are divided by number of games
Q <- as.matrix(sg[ ,stats] / sg$games)
# print(round(cor(Q), 2), print.gap = 2)

# PCA with prcomp()
sg_pca <- prcomp(Q, center = TRUE, scale. = TRUE)
sg_weights <- sg_pca$rotation[,1]

if (sum(sign(sg_weights)) < 0) {
  sg_weights = -1 * sg_weights
}

# Standard deviations
sg_sigmas <- apply(Q, 2, sd)

# Modified efficiency
sg_eff <- Q %*% (sg_weights / sg_sigmas)
sg$EFF <- sg_eff

# Subset data for position 'SF' (small forward)
# and add Missed Field Goals MFG, Missed Free Throws MFT, Turnovers TO
# (these variables have negative sign)
sf <- data %>%
  filter(position == 'SF') %>%
  mutate(MFT = (-1)*(free_throw_attempts - free_throws)) %>%
  mutate(MFG = (-1)*(field_goal_attempts - field_goals)) %>%
  mutate(TO = -1 * turnovers)

# head(sf)

# All variables are divided by number of games
K <- as.matrix(sf[ ,stats] / sf$games)
# print(round(cor(K), 2), print.gap = 2)

# PCA with prcomp()
sf_pca <- prcomp(K, center = TRUE, scale. = TRUE)
sf_weights <- sf_pca$rotation[,1]

if (sum(sign(sf_weights)) < 0) {
  sf_weights = -1 * sf_weights
}

# Standard deviations
sf_sigmas <- apply(K, 2, sd)

# Modified efficiency
sf_eff <- K %*% (sf_weights / sf_sigmas)
sf$EFF <- sf_eff

new <- merge(c, pf, all = TRUE)
new2 <- merge(new, pg, all=TRUE)
new3 <- merge(new2, sf, all=TRUE)
new4 <- merge(new3, sg, all=TRUE)

# head(new4)

chart <- subset(new4, select=c("name", "position", "points", "total_rebounds", 
                               "assists", "steals", "blocks","MFG", "MFT", "TO", 
                               "games", "EFF", "salary"))

chart$EFF <- chart$EFF[,1]

# head(chart)

write.csv(chart, "data/cleandata/eff-stats-salary.csv")

# ==============================================================================
# Value of Players

chart$value = chart$EFF/chart$salary

# Going to have to remove outliers. Will need to read in csv.
df_for_outliers <- read.csv("data/cleandata/roster-salary-stats.csv", 
                            stringsAsFactors = F)

# Order chart alphabetically for easy comparison to new df
chart <- arrange(chart, name)

# Add outliers column to chart
chart$outlier <- df_for_outliers$outlier

# Remove players who didn't make an appearance in at least 30 games
# and arrange by descending order of value

best_values <- head(chart %>% filter(games >= 30) %>% 
                arrange(desc(value)) %>%
                select(name, value), n = 20)


# Remove outliers so that players with salaries from two teams
# do not have deflated values
worst_values <- head(chart %>% filter(games >= 30, outlier == F) %>%
                 arrange(value) %>%
                 select(name, value), n =20)

row.names(best_values) <- c(1:20)
row.names(worst_values) <- c(1:20)


# ==============================================================================
# Best players

# Format to write to txt file
report_best <- paste0(row.names(best_values), ". ", 
               best_values$name, 
               ", Value:", 
               round(best_values$value, digits = 9))

# Index everything up by one to make space for title.
for(i in 20:1){
  report_best[i+1] <- report_best[i]
}

report_best[1] <- "   Highest Valued Players"

# ==============================================================================
# Worst players

report_worst <- paste0(row.names(worst_values), ". ", 
                      worst_values$name, 
                      ", Value:", 
                      round(worst_values$value, digits = 9))

for(i in 20:1){
  report_worst[i+1] <- report_worst[i]
}

report_worst[1] <- "   Lowest Valued Players"

report_all <- c(report_best, report_worst)

write(report_all, file = "data/cleandata/player_value_rankings.txt")

# eof