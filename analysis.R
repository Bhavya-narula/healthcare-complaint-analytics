# Healthcare Complaint Analytics
# Count model comparison: Poisson vs Negative Binomial vs ZINB
# Bhavya Narula

library(MASS)
library(pscl)
library(AER)
library(ggplot2)

# -------------------------
# Data
# -------------------------
compdat <- tryCatch(
  read.table("compdat.txt", header = TRUE, sep = "", stringsAsFactors = FALSE),
  error = function(e) read.delim("compdat.txt", header = TRUE, stringsAsFactors = FALSE)
)

compdat$residency  <- factor(compdat$residency, levels = c("N","Y"))
compdat$gender     <- factor(compdat$gender, levels = c("F","M"))
compdat$visits     <- as.numeric(compdat$visits)
compdat$complaints <- as.integer(compdat$complaints)
compdat$revenue    <- as.numeric(compdat$revenue)
compdat$hours      <- as.numeric(compdat$hours)

# -------------------------
# Models
# -------------------------
# Poisson (final spec used for comparison)
m1 <- glm(complaints ~ residency * gender + offset(log(visits)),
          family = poisson, data = compdat)

# Overdispersion test
dispersiontest(m1)

# Negative Binomial
m2 <- glm.nb(complaints ~ residency * gender + offset(log(visits)),
             data = compdat)

# IRR (incident rate ratios)
exp(coef(m2))

# Zero-Inflated Negative Binomial
m3 <- zeroinfl(complaints ~ residency * gender + offset(log(visits)) | residency + gender,
               data = compdat, dist = "negbin")

# Model comparison
AIC(m1, m2, m3)

# Vuong test: NB vs ZINB
vuong(m2, m3)

# -------------------------
# Key Visuals
# -------------------------
# Complaint rate by gender
ggplot(compdat, aes(x = gender, y = 1000 * complaints / visits)) +
  geom_boxplot(outlier.alpha = 0.7, na.rm = TRUE) +
  labs(title = "Complaint Rate by Gender",
       x = "Gender",
       y = "Complaints per 1,000 Visits")

# Complaints vs visits (exposure relationship)
ggplot(compdat, aes(x = visits, y = complaints)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Relationship between number of visits and complaints",
       x = "Number of visits",
       y = "Number of complaints")

# Residuals vs fitted (Poisson vs NB)
plot(fitted(m1), resid(m1, type = "pearson"),
     xlab = "Fitted values", ylab = "Pearson residuals",
     main = "Poisson: Pearson residuals vs fitted", pch = 19)
abline(h = 0, lwd = 2)

plot(fitted(m2), resid(m2, type = "pearson"),
     xlab = "Fitted values", ylab = "Pearson residuals",
     main = "Negative Binomial: Pearson residuals vs fitted", pch = 19)
abline(h = 0, lwd = 2)

# QQ plots
res_pois <- residuals(m1, type = "pearson")
res_nb   <- residuals(m2, type = "pearson")

qqnorm(res_pois, main = "Poisson: QQ plot of Pearson residuals", pch = 19)
qqline(res_pois, lwd = 2)

qqnorm(res_nb, main = "Negative Binomial: QQ plot of Pearson residuals", pch = 19)
qqline(res_nb, lwd = 2)

# Histogram
hist(compdat$complaints, breaks = 20,
     main = "Distribution of Complaints",
     xlab = "Number of Complaints", ylab = "Frequency")