source("./function/calculate_AI.R")
source("./function/Bruteforce_RI_RA.R")
source("./function/message_CA_PT_AI.R")

library(tidyverse)
library(shiny)
library(plotly)



function(input, output) {
  
  # Reactive expression to process inputs and calculate CAmin, CAmax, PT, AI
  processedInputs <- reactive({
    df_result1 <- message_CA_PT_AI(input$PI, input$LL, input$SSstanding,
                                  input$SSsitting, input$Beta, input$FA)[[1]]
    #df_result2 <- message_CA_PT_AI(input$PI, input$LL, input$SSstanding,
    #                               input$SSsitting, input$Beta, input$FA)[[2]]
    # Extract values
    list(
      CAmin = df_result1[which(df_result1$Variables == 'CAmin'), 2],
      CAmax = df_result1[which(df_result1$Variables == 'CAmax'), 2],
      PT = df_result1[which(df_result1$Variables == 'PT'), 2],
      AI = df_result1[which(df_result1$Variables == 'AI'), 2],
      text_message1 = message_CA_PT_AI(input$PI, input$LL, input$SSstanding,
                                      input$SSsitting, input$Beta, input$FA)[[2]],
      text_message2 = message_CA_PT_AI(input$PI, input$LL, input$SSstanding,
                                       input$SSsitting, input$Beta, input$FA)[[3]]
    )
  })
  
  # Reactive expression for Bruteforce_RI_RA, depends on processedInputs
  bruteforceResults <- reactive({
    # Ensure the dependencies are ready
    if (is.null(input$d) || is.null(input$ESP)) {
      return(NULL)
    }
    req(processedInputs())  # This ensures that processedInputs has been calculated
    AI <- processedInputs()$AI
    PT <- processedInputs()$PT
    
    # Call the Bruteforce_RI_RA function with the reactive values
    Bruteforce_RI_RA(AI, PT, input$d, input$ESP)
  })
  
  # Render plot output
  # Calculate Intersection Safe Zone as a reactive expression
  intersectionSafeZone <- reactive({
    req(bruteforceResults())
    df_result <- bruteforceResults()
    
    x_fsz <- df_result$x
    y_fsz <- df_result$y
    x_asz <- rep(30:45, each = 21)
    y_asz <- rep(5:25, times = 16)
    
    # Filter for intersection
    x_isz <- x_fsz[x_fsz %in% x_asz & y_fsz %in% y_asz]
    y_isz <- y_fsz[x_fsz %in% x_asz & y_fsz %in% y_asz]
    
    list(x = x_isz, y = y_isz)
  })
  
  # Render the main plot with refined code
  output$plot <- renderPlotly({
    req(bruteforceResults(), processedInputs(), intersectionSafeZone())
    CAmin <- processedInputs()$CAmin
    CAmax <- processedInputs()$CAmax
    df_result <- bruteforceResults()
    isz <- intersectionSafeZone()  # Use the pre-computed intersection safe zone
    
    ## if having intercetion 
    if (length(isz$x) > 0){
       plot_ly() |>
       add_markers(x = df_result$x, y = df_result$y, color = I("#26547C"), size = 1.8, name = "Functional Safe Zone",
                   hovertemplate = paste("Functional Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
       add_markers(x = rep(30:45, each = 21), y = rep(5:25, times = 16), color = I("#FFD166"), size = 1.8, name = "Anatomical Safe Zone",
                   hovertemplate = paste("Anatomical Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
       add_markers(x = isz$x, y = isz$y, color = I("#EF476F"), size = 1.8, name = "Intersection Safe Zone",
                   hovertemplate = paste("Intersection Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
       add_segments(x = c(29.5, 29.5, 29.5, 45.5), xend = c(45.5, 45.5, 29.5, 45.5),
                   y = c(CAmax + 0.5, CAmin - 0.5, CAmin - 0.5, CAmin - 0.5), yend = c(CAmax + 0.5, CAmin - 0.5, CAmax + 0.5, CAmax + 0.5),
                   line = list(color = "black", dash = "dash", width = 1.5), name = "Combined Anteversion Safe Zone",
                   hovertemplate = paste("Combined Anteversion Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
      layout(xaxis = list(title = "Inclination (°)", range = c(20, 55), showgrid = FALSE),
             yaxis = list(title = "Anteversion (°)", range = c(0, 40), showgrid = FALSE),
             legend = list(orientation = "v"))
         }
    else{
      plot_ly() |>
        add_markers(x = df_result$x, y = df_result$y, color = I("#26547C"), size = 1.8, name = "Functional Safe Zone",
                    hovertemplate = paste("Functional Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
        add_markers(x = rep(30:45, each = 21), y = rep(5:25, times = 16), color = I("#FFD166"), size = 1.8, name = "Anatomical Safe Zone",
                    hovertemplate = paste("Anatomical Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
        add_segments(x = c(29.5, 29.5, 29.5, 45.5), xend = c(45.5, 45.5, 29.5, 45.5),
                     y = c(CAmax + 0.5, CAmin - 0.5, CAmin - 0.5, CAmin - 0.5), yend = c(CAmax + 0.5, CAmin - 0.5, CAmax + 0.5, CAmax + 0.5),
                     line = list(color = "black", dash = "dash", width = 1.5), name = "Combined Anteversion Safe Zone",
                     hovertemplate = paste("Combined Anteversion Safe Zone<br>Inclination: %{x}<br>Anteversion: %{y}<extra></extra>")) |>
        add_text(x = 50, y= 38, text = "No Intersection Safe Zone",color = I("red"),showlegend = FALSE) |>
        layout(xaxis = list(title = "Inclination (°)", range = c(20, 55), showgrid = FALSE),
               yaxis = list(title = "Anteversion (°)", range = c(0, 40), showgrid = FALSE),
               legend = list(orientation = "v"))
      
    } 
  })
      
  # Render table output with simplified code
  output$table <- DT::renderDataTable({
    req(intersectionSafeZone())
    isz <- intersectionSafeZone()  # Use the pre-computed intersection safe zone
    
    DT::datatable(data.frame(Inclination = isz$x, Anteversion = isz$y))
  })
  # Render text output
  output$text_message1 <- renderText({ 
    text_message1 <- processedInputs()$text_message1
    print(text_message1)})
  
  output$text_message2 <- renderText({ 
    text_message2 <- processedInputs()$text_message2
    print(text_message2)})
}
