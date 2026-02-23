# Healthcare Complaint Analytics  
### Count Regression Model Comparison (Poisson vs Negative Binomial vs ZINB)

---

## Overview

This project investigates determinants of patient complaint frequency among emergency department doctors using structured count regression modelling. The objective was to identify demographic and professional risk factors while addressing overdispersion and potential zero inflation in complaint data.

---

## Problem Context

Patient complaints are discrete, right-skewed, and exposure-dependent (based on number of visits). Traditional linear modelling is inappropriate. This analysis applies count regression techniques to model complaint rates and evaluate risk multipliers.

---

## Analytical Approach

- Poisson Regression (baseline)
- Negative Binomial Regression (to address overdispersion)
- Zero-Inflated Negative Binomial (to test structural zeros)

Model selection was based on:

- Akaike Information Criterion (AIC)
- Overdispersion testing
- Vuong test for non-nested models

An exposure offset (`log(visits)`) was included to model complaint rates rather than raw counts.

---

## Key Findings

- Significant overdispersion detected in Poisson model.
- Negative Binomial model provided superior fit (ΔAIC ≈ 44).
- Zero-inflation not statistically justified.
- Male doctors exhibited ~5.4x higher complaint rates.
- Resident doctors exhibited ~3.3x higher complaint rates.
- Significant interaction effect between residency and gender.

---

## Business Implications

Findings highlight the importance of demographic and experience-based factors in complaint risk. Results support targeted communication training, monitoring frameworks, and exposure-adjusted performance evaluation in healthcare operations.

---

## Tools Used

- R  
- MASS  
- pscl  
- AER  
- ggplot2  

---

## Repository Contents

- `analysis.R` – Clean statistical modelling workflow  
- `Healthcare_Complaint_Analytics_Report.pdf` – Full analytical report  
