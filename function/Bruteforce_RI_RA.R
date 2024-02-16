source("./function/calculate_AI.R")
Bruteforce_RI_RA <- function(AI, PT, d,ESP ) {
  result_x <- numeric()
  result_y <- numeric()
  # ESP <- 3
  
  # Brute force over RA and RI
  for (RA in 0:40) {
    for (RI in 20:55) {
      if (abs(AI - calculate_AI(RA, RI, PT, d)) < ESP) {
        result_x <- c(result_x, RI)
        result_y <- c(result_y, RA)
      }
    }
  }
  
  return(data.frame(x = result_x, y = result_y))
}


