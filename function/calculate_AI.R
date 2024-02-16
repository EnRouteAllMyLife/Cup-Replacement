calculate_AI <- function(RA, RI, PT, d) {
  # Load necessary library
  library(pracma)
  
  # Convert degrees to radians
  RA <- deg2rad(RA)
  RI <- deg2rad(RI)
  PT <- deg2rad(PT)
  
  # Initial vector
  V1 <- c(0, 0, -1)
  
  # Rotation matrix M1
  M1 <- matrix(c(1, 0, 0,
                 0, cos(RA), -sin(RA),
                 0, sin(RA), cos(RA)), nrow = 3, byrow = TRUE)
  
  # V2 = M1 %*% V1
  V2 <- M1 %*% V1
  
  # Matrix M2
  M2 <- matrix(c(cos(-RI * d), 0, sin(-RI * d),
                 0, 1, 0,
                 -sin(-RI * d), 0, cos(-RI * d)), nrow = 3, byrow = TRUE)
  
  # V3 = M2 %*% V2
  V3 <- M2 %*% V2
  
  # Matrix M3
  M3 <- matrix(c(1, 0, 0,
                 0, cos(PT), -sin(PT),
                 0, sin(PT), cos(PT)), nrow = 3, byrow = TRUE)
  
  # V4 = M3 %*% V3
  V4 <- M3 %*% V3
  
  Vp <- c(0, 1, 1)
  
  # Hadamard Product
  V5 <- V4 * Vp
  
 # V1_L2Norm <- norm(V1, "F")
 # V5_L2Norm <- norm(V5, "F")
  V1_L2Norm <- sqrt(sum(V1^2))
  V5_L2Norm <- sqrt(sum(V5^2))
  
  AI <- acos(sum(V1 * V5) / (V1_L2Norm * V5_L2Norm))
  return(round(rad2deg(AI), 2))
}
