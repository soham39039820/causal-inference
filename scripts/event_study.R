# -------------------------------
# 03_event_study.R
# Event-Study Analysis
# -------------------------------

# Load libraries
library(dplyr)
library(fixest)
library(ggplot2)

# Load data
data <- read.csv("data/simulated_data.csv")

# Create relative time variable
data <- data %>%
  mutate(event_time = year - 2015)

# Event-study model
event_model <- feols(
  cognition_score ~ i(event_time, treated, ref = -1) | id + year,
  data = data
)

# Print summary
summary(event_model)

# Plot event study using iplot from fixest
iplot(event_model,
      main = "Event Study: Effect of Treatment on Cognition",
      xlab = "Years Since Treatment",
      ylab = "Effect on Cognitive Score")

# Save plot to output
ggsave("output/plots/event_study.png", width = 7, height = 5)

cat("Event-study analysis complete. Plot saved in 'output/plots/'\n")