# Loading the libraries

library(pacman)
p_load(
  rio,
  markovchain,
  readxl
)

# Loading the data

moody_tpm <- import("transition-matrix-moody.xlsx")

> mat <- as.matrix(moodys_tpm)

# Define states
> states <- c("WR", "C","Ca","Caa3","Caa2","Caa1", "B3","B2","B1", "Ba3", "Ba2","Ba1","Baa3","Baa2","Baa1","A3","A2","A1","Aa3", "Aa2","Aa1","Aaa")

# Convert data frame to matrix and assign row/column names
transition_matrix <- as.matrix(mat)
rownames(transition_matrix) <- states
colnames(transition_matrix) <- states

# Remove the first row if it contains state names as text
if (all(states %in% transition_matrix[1, ])) {   
  transition_matrix <- transition_matrix[-1, ]
}

# Create the Markov chain object
mc <- new("markovchain", states = states, transitionMatrix = transition_matrix)  

# Analyze Markov chain properties
# used to find the communicating states
communicatingClasses(mc)

# Used to find the steady states
steadyStates(mc)

# Used to find if the matrix is reducible or not
is.irreducible(mc)

# Used to find if states are recurrent
recurrentStates(mc)
recurrentClasses(mc)

# Used to find if states are transient
transientStates(mc)
transientClasses(mc)

# Used to find if there are absorbing states
absorbingStates(mc)
absorptionProbabilities(mc)

# Used to find if there are non null persistent states
non_null_persistent_states <- setdiff(mc@states,absorbing_states)