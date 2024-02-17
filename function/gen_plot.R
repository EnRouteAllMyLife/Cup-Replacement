source("./function/calculate_AI.R")
source("./function/Bruteforce_RI_RA.R")
source("./function/message_CA_PT_AI.R")

library(tidyverse)
library(plotly)

gen_plot = function(PI,LL, SSstanding, SSsitting, 
                    d , ESP, Beta, FA){
  df_result = message_CA_PT_AI(PI,LL, SSstanding, SSsitting,Beta,FA)[[1]]
  # 赋值
  CAmin = df_result[which(df_result$Variables =='CAmin'),2]
  CAmax = df_result[which(df_result$Variables =='CAmax'),2]
  PT = df_result[which(df_result$Variables =='PT'),2]
  AI = df_result[which(df_result$Variables =='AI'),2]
  
  df_result3 = Bruteforce_RI_RA(AI, PT, d,ESP )
  
  x_fsz = df_result3$x
  y_fsz = df_result3$y
  x_asz = rep(30:45, each = 21)
  y_asz = rep(5:25, times = 16)
  x_isz = c()
  y_isz = c()
  
  for (i in 1:length(x_fsz)){
    if(x_fsz[i] %in% x_asz & y_fsz[i] %in% y_asz){
      x_isz = c(x_isz, x_fsz[i])
      y_isz = c(y_isz, y_fsz[i])
    } 
  }
  
  plot_ly() |>
    add_markers(
      x = df_result3$x, y = df_result3$y,
      #color = ~price, text = ~text_label, 
      color = I("#2b6a99"),size = 1.8, name = "Functional Safe Zone") |>
    add_markers(x = rep(30:45, each = 21), y = rep(5:25, times = 16), 
                color = I("#f16c23"), size = 1.8,
                name = "Anatomical Safe Zone")|>
    add_markers(x = x_isz,
                y =  y_isz,
                color = I("#1b7c3d"), size = 1.8,
                name = "Intersection Safe Zone")|>
    add_segments(x = c(29.5,29.5,29.5,45.5), xend = c(45.5,45.5,29.5, 45.5),
                 y = c(CAmax + 0.5,CAmin - 0.5,CAmin - 0.5,CAmin - 0.5), 
                 yend = c(CAmax + 0.5, CAmin - 0.5,CAmax + 0.5, CAmax + 0.5),
                 line = list(color = "black", dash = "dash", width = 1.5), 
                 name = "Combined Anterversion Safe Zone") |>
    layout(xaxis = list(title = "Inclination (°)", range = c(20, 55), showgrid = FALSE),
           yaxis = list(title = "Anteversion (°)", range = c(0, 40), showgrid = FALSE),
           legend = list(orientation = "h", x = 0.3, y = -0.1))
  
   
}


  
gen_plot(PI = 46,LL =20, SSstanding = 50, SSsitting = 45 ,d = 1, ESP = 3, Beta = -10 ,FA=5)
PI = 50
LL =20
SSstanding = 50
SSsitting = 20
d = 1
ESP = 3
Beta = 0
FA= 0