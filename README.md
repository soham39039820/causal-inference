# Causal Inference

This repository demonstrates **quasi-experimental methods** — Difference-in-Differences (DiD) and Event-Study analysis — using **simulated panel data**. These examples showcase skills in causal inference, observational data analysis, and reproducible research.

---

## 1. Problem Setup

We simulate a panel of **1,000 individuals** observed from **2010 to 2020**. A subset of individuals receives a “treatment” (e.g., a policy intervention or vaccination) starting in **2015**. The goal is to estimate the **causal effect** of treatment on `cognition_score`.

**Data variables:**

- `id`: individual identifier  
- `year`: year of observation  
- `age`: individual age  
- `treated`: 1 if the individual is in the treatment group, 0 otherwise  
- `post`: 1 if year ≥ 2015, 0 otherwise  
- `cognition_score`: simulated outcome  
- `event_time`: relative time to treatment (`year - 2015`)  

**Number of observations:** 1,000 individuals × 11 years = **11,000 observations**

---

## 2. Difference-in-Differences (DiD)

The standard DiD model with individual and year fixed effects is:

Y_it = α_i + λ_t + β * (T_i × Post_t) + ε_it

where:  
- Y_it = cognition score for individual i at year t  
- α_i = individual fixed effect  
- λ_t = year fixed effect  
- T_i = 1 if treated, 0 otherwise  
- Post_t = 1 if year ≥ 2015, 0 otherwise  
- β = treatment effect (causal estimate)  
- ε_it = error term  

**Results:**

| Variable           | Estimate | Std. Error | Significance |
|------------------|----------|------------|-------------|
| treated × post    | 1.995    | 0.077      | ***         |

- Observations: 11,000  
- R²: 0.534  
- Within R²: 0.063  

**Interpretation:**  
- The DiD model estimates that the treatment increases the cognition score by approximately **2 points** post-intervention, controlling for individual and year fixed effects.  
- The effect is **highly statistically significant** (p < 0.01).  
- Pre-treatment trends (years < 2015) are flat, consistent with the **parallel trends assumption** required for causal identification.  
- Parallel trends are visualized in `output/plots/parallel_trends.png`.  

This analysis demonstrates a **causal effect** of the intervention under standard DiD assumptions.

---

## 3. Event-Study Analysis

To explore **dynamic treatment effects**, we estimate an event-study specification:

Y_it = α_i + λ_t + Σ_{k ≠ -1} β_k * 1[EventTime_it = k] * T_i + ε_it

- EventTime_it = t - t0 (years relative to treatment)  
- β_k measures the effect k years from treatment  
- Reference period: k = -1  

**Results (select):**

| Event Time | Estimate | Std. Error | Significance |
|------------|---------|------------|-------------|
| -5         | 0.147   | 0.179      | n.s.        |
| 0          | 2.052   | 0.179      | ***         |
| 1          | 2.114   | 0.179      | ***         |
| 2          | 2.205   | 0.179      | ***         |

**Interpretation:**  
- No pre-treatment trends (years < 0 have estimates close to 0), supporting the **parallel trends assumption**.  
- The treatment effect appears at year 0 and persists in subsequent years, consistent with a **causal effect**.  
- Dynamic treatment effects are visualized in `output/plots/event_study.png`.

---

## 4. Reproducibility

The repository contains **three R scripts**:

1. `scripts/generate_data.R` – Simulates panel data for the example  
2. `scripts/analysis_DiD.R` – Runs Difference-in-Differences analysis and saves output  
3. `scripts/event_study.R` – Runs Event-Study analysis and saves output  

**Output folders:**

- `data/` – Simulated dataset (`simulated_data.csv`)  
- `output/plots/` – Figures for parallel trends and event-study  
- `output/tables/` – Regression tables (`did_results.txt`)  

**Run scripts in sequence:**

```bash
Rscript scripts/generate_data.R
Rscript scripts/analysis_DiD.R
Rscript scripts/event_study.R