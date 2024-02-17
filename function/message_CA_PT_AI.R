message_CA_PT_AI = function(PI,LL, SSstanding, SSsitting,Beta,FA){
  Delta_SS = SSstanding - SSsitting
  
  #msgs1 = c()
  msgs2 = c()
  
  if (PI - LL <= 10 & Delta_SS > 30){
    CAmin = 25
    CAmax = 35
    msgs1 = "Normal spine and hypermobile pelvis"
    msgs2 = "Suggestions：Anteversion = 12°～20°, Inclination = 35°～40°, Combined Anteversion = 25°～35°"
  }
  
  if (PI - LL <= 10  & Delta_SS >10 & Delta_SS <= 30){
    CAmin = 25
    CAmax = 45
    msgs1 = "Normal spine and normal pelvic mobility"
    msgs2 = "Suggestions：Anteversion = 15°～25°, Inclination = 40°～45°, Combined Anteversion = 25°～45°"
  }
  
  if (PI - LL <= 10 & Delta_SS <= 10){
    CAmin = 35
    CAmax = 45  
    msgs1 = "Normal spine and stiff pelvis\n"
    msgs2 = "Suggestions：Anteversion = 25°～30°, Inclination = 45°, Combined Anteversion = 35°～45°"
    
  }
  
  if (PI - LL > 10 & Delta_SS > 10){
    CAmin = 25
    CAmax = 35  
    msgs1 = "Flat back and normal pelvic mobility"
    if (SSstanding > 30){
      msgs2 = "Suggestions：Anteversion = 20°～25°, Inclination = 40°～45°, Combined Anteversion = 25°～35°"
    }
    if (SSstanding <= 30 & SSstanding > 17){
      msgs2 = "Suggestions：Anteversion = 20°～25°, Inclination = 40°, Combined Anteversion = 25°～35°"
    }
    else{
      msgs2 = "Suggestions：Anteversion = 20°, Inclination = 40°, Combined Anteversion = 25°～45°"
    }
  }
  
  if(PI - LL > 10 & Delta_SS <= 10){
    CAmin = 25
    CAmax = 35 
    msgs1 = "Flat back and stiff pelvis"
    if (SSstanding > 17){
      msgs2 = "Suggestions：Anteversion = 25°, Inclination = 40°, Combined Anteversion = 25°～35°"
    }
    else{
      msgs2 = "Suggestions：Anteversion = 25～35°, Inclination = 45°, Combined Anteversion = 35°～45°"
    }
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
  #print(msgs)
  return(list(data.frame(Variables = c("CAmin","CAmax","PT","AI"),
              Values = c(CAmin,CAmax, PT, AI)),
              msgs1,
              msgs2))
}
#df_result = message_CA_PT_AI(PI = 46,LL =20, SSstanding = 50, SSsitting = 45 ,Beta = 10 ,FA=5)
#df_result[which(df_result$Variables =='AI'),2]
#message_CA_PT_AI(PI = 46,LL = 40, SSstanding = 50, SSsitting = 45 ,Beta = 10 ,FA=5)
