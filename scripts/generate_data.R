# -------------------------------
# 01_simulate_data.R
# Simulate panel data for DiD and event-study demonstration
# -------------------------------

# Load libraries
library(dplyr)

# Create folders if they don't exist
dir.create("data", showWarnings = FALSE)
dir.create("output/plots", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)

# Set seed for reproducibility
set.seed(123)

# Simulate individuals and years
n_individuals <- 1000
years <- 2010:2020

data <- expand.grid(id = 1:n_individuals, year = years) %>%
  arrange(id, year)

# Assign age and treatment
data <- data %>%
  group_by(id) %>%
  mutate(
    age = sample(60:80, 1),
    treated = sample(c(0,1), 1, prob = c(0.5, 0.5))
  ) %>%
  ungroup()

# Define policy/intervention year
policy_year <- 2015

data <- data %>%
  mutate(
    post = ifelse(year >= policy_year, 1, 0),
    time_trend = year - 2010
  )

# Generate cognition scores with treatment effect
data <- data %>%
  mutate(
    baseline = 50 + 0.3 * age - 0.2 * time_trend,
    treatment_effect = 2 * treated * post,
    noise = rnorm(n(), 0, 2),
    cognition_score = baseline + treatment_effect + noise
  )

# Save dataset
write.csv(data, "data/simulated_data.csv", row.names = FALSE)

cat("Data simulation complete. Dataset saved in 'data/simulated_data.csv'\n")