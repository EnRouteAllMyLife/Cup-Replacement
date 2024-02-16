source("./function/calculate_AI.R")
source("./function/Bruteforce_RI_RA.R")
source("./function/message_CA_PT_AI.R")

library(tidyverse)
library(plotly)

gen_plot = function(PI,LL, SSstanding, SSsitting, 
                    d , ESP, Beta, FA){
  df_result = message_CA_PT_AI(PI,LL, SSstanding, SSsitting,Beta,FA)
  # 赋值
  CAmin = df_result[which(df_result$Variables =='CAmin'),2]
  CAmax = df_result[which(df_result$Variables =='CAmax'),2]
  PT = df_result[which(df_result$Variables =='PT'),2]
  AI = df_result[which(df_result$Variables =='AI'),2]
  
  df_result = Bruteforce_RI_RA(AI, PT, d,ESP )
  df_result |>
    plot_ly(
      x = ~x, y = ~y, type = "scatter", mode = "markers",
      #color = ~price, text = ~text_label, 
      alpha = 0.5) |>
    layout(#title = 'Scatter Plot',
           xaxis = list(title = "Inclination (°)",
                        range = c(20, 55),
                        showgrid = FALSE),
           yaxis = list(title = "Anteversion (°)", 
                        range = c(0, 40),
                        showgrid = FALSE))
}


gen_plot(PI = 46,LL =20, SSstanding = 50, SSsitting = 45 ,d = 1, ESP = 3, Beta = -10 ,FA=5)
