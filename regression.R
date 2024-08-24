# Loading the libraries

library(pacman)
p_load(
  readxl,
  dplyr,
  car, 
  randtests
)

# Read data from Excel files
all_factors <- read_excel("data.xlsx")
indicator_data <- read_excel("global_south.xlsx")

# Select columns and filter complete cases
filtered_data <- all_factors %>%
  select(names(all_factors)) %>%
  filter(complete.cases(.))

# Create indicators for global south and G20 countries
updated_data <- filtered_data %>%
  mutate(global_south_indicator = ifelse(countries %in% indicator_data$global_south, 1, 0),
         g20_indicator = ifelse(countries %in% indicator_data$g20, 1, 0))

# Remove unnecessary columns and create logarithm of GDP
final_data <- updated_data %>%
  select(-countries, -moodys_rating, -fitch_rating, -s_rating,
         -moody_numeric, -fitch_numeric, -s_p_numeric,
         -basu_rating, -mean_rating, -gdp_cur) %>%
  mutate(log_gdp_current = log(updated_data$gdp_cur))

# Square of the dependent variable (e.g., Moody's numeric rating)
dependent_variable <- updated_data$moody_numeric^2

# Fit linear regression model
regression_model <- lm(dependent_variable ~ ., data = final_data)
# Summary of the regression model
summary(regression_model)

# Analysis of variance
anova_model <- aov(regression_model)
summary(anova_model)

# Variance inflation factors
vif(regression_model)

# Diagnostic plots
plot(regression_model)

# Assumptions testing
runs.test(regression_model$residuals)
shapiro.test(regression_model$residuals)
ncvTest(regression_model)
