message_CA_PT_AI = function(PI,LL, SSstanding, SSsitting,Beta,FA){
  Delta_SS = SSstanding - SSsitting
  
  msgs = c()
  
  if (PI - LL <= 10 & Delta_SS >= 30){
    CAmin = 25
    CAmax = 35
  }
  
  if (PI - LL <= 10  & Delta_SS >10 & Delta_SS < 30){
    CAmin = 25
    CAmax = 45
  }
  
  if (PI - LL <= 10 & Delta_SS <= 10){
    CAmin = 35
    CAmax = 45  
  }
  
  if (PI - LL > 10 & Delta_SS > 10){
    CAmin = 25
    CAmax = 35  
  }
  
  if(PI - LL > 10 & Delta_SS <= 10){
    CAmin = 25
    CAmax = 35 
  }
  
  SSi = PI * 2/3 + 5
  PTi = PI / 3 - 5
  SAAi = ( 90 + PI ) / 2
  PAAi = ( 90 + PI ) / 2
  AIi = 40 - PI / 6
  Alphai = 180 - SAAi - PAAi
  # 计算理想的AI
  # 第一次矫正
  SAAm1 = SAAi + (SSi - SSstanding) * 3/4
  PAAm1 = PAAi - (SSi - SSstanding)* 3/4
  Alpham1 = 180 -SAAm1 - PAAm1
  AIm1 = AIi + (SSi - SSstanding)/4
  #第二次矫正
  SAAm2 = SAAm1 + (25 - Delta_SS )/2
  PAAm2 = PAAm1 - (25 - Delta_SS )/2
  Alpham2 = 180 -SAAm2 - PAAm2 # (eqaul to alpham1)
  
  PTstanding  = 90 - SSstanding - Alpham2 - Beta
  PTsitting  = 90 - SSsitting - Alpham2 - Beta
  AIm2standing = AIm1 + (25 - Delta_SS )/2
  AIm2sitting = AIm2standing + Delta_SS
  
  AI = AIm2standing
  PT = PTstanding
  ########################## 画图区域 ##########################
  PT = PT - Beta
  AI = AI - Beta
  CAmin = CAmin - FA
  CAmax = CAmax - FA
  
  return(data.frame(Variables = c("CAmin","CAmax","PT","AI"),
                Values = c(CAmin,CAmax, PT, AI)))
}
#df_result = message_CA_PT_AI(PI = 46,LL =20, SSstanding = 50, SSsitting = 45 ,Beta = 10 ,FA=5)
#df_result[which(df_result$Variables =='AI'),2]
