# Causal Inference Demo: Difference-in-Differences & Event-Study Analysis

This repository demonstrates quasi-experimental methods—Difference-in-Differences (DiD) and Event-Study. We employed simulated panel data. The examples are intended to showcase skills in causal inference, observational data analysis, and reproducible research.

## 1. Problem Setup

We simulate a panel of 1,000 individuals observed from 2010 to 2020. A subset of individuals receives a “treatment” (e.g., a policy intervention or vaccination) starting in 2015. The goal is to estimate the causal effect of treatment on `cognition_score`.

**Data:**
- `id`: individual identifier  
- `year`: year of observation  
- `age`: individual age  
- `treated`: 1 if the individual is in the treatment group, 0 otherwise  
- `post`: 1 if year ≥ 2015, 0 otherwise  
- `cognition_score`: simulated outcome  
- `event_time`: relative time to treatment (`year - 2015`)  

---

## 2. Difference-in-Differences (DiD)

The standard DiD model with individual and year fixed effects is:

\[
Y_{it} = \alpha_i + \lambda_t + \beta \cdot (T_i \times Post_t) + \epsilon_{it}
\]

where:  
- \(Y_{it}\) = cognition score for individual \(i\) at year \(t\)  
- \(\alpha_i\) = individual fixed effect  
- \(\lambda_t\) = year fixed effect  
- \(T_i\) = 1 if treated, 0 otherwise  
- \(Post_t\) = 1 if year ≥ 2015, 0 otherwise  
- \(\beta\) = treatment effect (causal estimate)  
- \(\epsilon_{it}\) = error term  

**Results:**
| Variable           | Estimate | Std. Error | Significance |
|------------------|----------|------------|-------------|
| treated × post    | 1.995    | 0.077      | ***         |
- Observations: 11,000  
- R²: 0.534  
- Within R²: 0.063  

**Interpretation:**  
The treatment increases cognition score by ~2 points on average post-intervention, controlling for individual and year effects. Parallel trends are checked using the `output/plots/parallel_trends.png` figure.

---

## 3. Event-Study Analysis

To explore **dynamic treatment effects**, we estimate an event-study specification:

\[
Y_{it} = \alpha_i + \lambda_t + \sum_{k \neq -1} \beta_k \cdot \mathbf{1}[EventTime_{it} = k] \cdot T_i + \epsilon_{it}
\]

- \(EventTime_{it} = t - t_0\) (years relative to treatment)  
- \(\beta_k\) measures the effect \(k\) years from treatment  
- Reference period: \(k=-1\)  

**Results (select):**
| Event Time | Estimate | Std. Error | Significance |
|------------|---------|------------|-------------|
| -5         | 0.147   | 0.179      | n.s.        |
| 0          | 2.052   | 0.179      | ***         |
| 1          | 2.114   | 0.179      | ***         |
| 2          | 2.205   | 0.179      | ***         |

**Interpretation:**  
No pre-treatment trends (estimates around 0 for years <0), satisfying parallel trends. Treatment effect emerges at year 0 and persists, consistent with causal effect. Event-study plot is available in `output/plots/event_study.png`.

---

---

## 4. Reproducibility

Run scripts in sequence:

```bash
scripts/simulate_data.R
scripts/did_analysis.R
scripts/event_study.R
