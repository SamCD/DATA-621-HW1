#install.packages("RCurl")
library(RCurl)
#install.packages("ggplot2")
library(ggplot2)

trainLink <- getURL('https://raw.githubusercontent.com/SamCD/DATA-621-HW1/master/moneyball-training-data.csv')
train <- read.csv(text = trainLink)

testLink <- getURL('https://raw.githubusercontent.com/SamCD/DATA-621-HW1/master/moneyball-evaluation-data.csv')
test <- read.csv(text = testLink)

summary(train)

#see which fields have the most NA values
colSums(is.na(train))

#split into offensive and defensive categories and correct for negative-impact variables
offense <- train[c(
    "TARGET_WINS"
  , "TEAM_BATTING_H"
  , "TEAM_BATTING_2B"
  , "TEAM_BATTING_3B"
  , "TEAM_BATTING_HR"
  , "TEAM_BATTING_BB"
  , "TEAM_BATTING_HBP"
  , "TEAM_BATTING_SO"
  , "TEAM_BASERUN_SB"
  , "TEAM_BASERUN_CS"
)
]

offense["TEAM_BATTING_SO"] <- offense["TEAM_BATTING_SO"] * -1
offense["TEAM_BASERUN_CS"] <- offense["TEAM_BASERUN_CS"] * -1

defense <- train[c(
    "TARGET_WINS"
  , "TEAM_FIELDING_E"
  , "TEAM_FIELDING_DP"
  , "TEAM_PITCHING_BB"
  , "TEAM_PITCHING_H"
  , "TEAM_PITCHING_HR"
  , "TEAM_PITCHING_SO"
)]

defense["TEAM_FIELDING_E"] <- defense["TEAM_FIELDING_E"] * -1
defense["TEAM_PITCHING_BB"] <- defense["TEAM_PITCHING_BB"] * -1
defense["TEAM_PITCHING_H"] <- defense["TEAM_PITCHING_H"] * -1
defense["TEAM_PITCHING_HR"] <- defense["TEAM_PITCHING_HR"] * -1

#see which variable correlate the strongest with winning
cor(offense$TARGET_WINS,offense, use="complete.obs")
cor(defense$TARGET_WINS,defense, use="complete.obs")

#hits(offense) and walks(defense) appear to correlate the strongest
#so we plot against wins
plot(offense$TEAM_BATTING_H,offense$TARGET_WINS)
plot(defense$TEAM_PITCHING_BB,defense$TARGET_WINS)
