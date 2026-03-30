# -------------------------------
# 02_did_analysis.R
# Difference-in-Differences (DiD) Analysis
# -------------------------------

# Load libraries
library(dplyr)
library(fixest)
library(ggplot2)

# Load data
data <- read.csv("data/simulated_data.csv")

# Run DiD model with individual and year fixed effects
did_model <- feols(
  cognition_score ~ treated:post | id + year,
  data = data
)

# Save regression table
etable(did_model, file = "output/tables/did_results.txt")

# Parallel trends plot
plot_data <- data %>%
  group_by(year, treated) %>%
  summarise(mean_score = mean(cognition_score), .groups = "drop")

ggplot(plot_data, aes(x = year, y = mean_score, color = factor(treated))) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 2015, linetype = "dashed") +
  labs(
    title = "Parallel Trends Check",
    x = "Year",
    y = "Average Cognitive Score",
    color = "Treated"
  ) +
  theme_minimal()

# Save plot
ggsave("output/plots/parallel_trends.png", width = 7, height = 5)

cat("DiD analysis complete. Table and plot saved in 'output/'\n")