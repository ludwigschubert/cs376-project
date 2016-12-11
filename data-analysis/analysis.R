# analysis.R
# Runs statistic analysis on performance data

# Setup -------------------------------------------------------------------

library(dplyr)
library(pwr)

input_file = "cleaned_performance.csv"

# Load --------------------------------------------------------------------

performances = read.csv(input_file)
performances$Condition = as.factor(performances$Condition)

# Rename Columns ----------------------------------------------------------

performances = performances %>%
  mutate(InterventionDiff = PostInterventionScore - PreInterventionScore)

# look at means manually-looks promising!

ttest = t.test(performances %>% filter(Condition == 1) %>% select(InterventionDiff), 
               performances %>% filter(Condition == 0) %>% select(InterventionDiff), 
               paired=F, # non-paired because we're testing between subjects, not within
               var.equal=F,  # Welch
               alternative="two.sided")

ttest

# Power Analysis ----------------------------------------------------------

diff_means = performances %>% 
  group_by(Condition) %>%
  summarise(DiffMean = mean(InterventionDiff))
d = abs(diff_means$DiffMean[1] - diff_means$DiffMean[2]) / sd(performances$InterventionDiff)

pwr.t.test(d=d,
           power=.7,
           sig.level=.05,
           type="two.sample",
           alternative="two.sided")