
# Load libraries
library(pacman)
p_load(rio, janitor, dplyr, markovchain, ggplot2,)

# Load the data
data <- import("credit-transitions.xlsx") %>%
  clean_names() %>%
  mutate(ratings_numeric = ratings_numeric + 1)

# Define the transition matrix
ratings <- unique(data$ratings)
transition_matrix <- matrix(0, nrow = length(ratings), ncol = length(ratings),dimnames = list(ratings, ratings),)

# Loop over each combination of ratings
for (i in nrow(data):2) {
  current_ratings <- data$ratings_numeric[i]
  next_ratings <- data$ratings_numeric[i - 1]
  
  # Check if the ratings are for the same country
  if (data$countries[i] == data$countries[i - 1]) {
    transition_matrix[current_ratings, next_ratings] <- transition_matrix[current_ratings, next_ratings] + 1
  }
}

