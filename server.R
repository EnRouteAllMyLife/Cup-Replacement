source("./function/calculate_AI.R")
source("./function/Bruteforce_RI_RA.R")
source("./function/message_CA_PT_AI.R")

library(tidyverse)
library(shiny)
library(plotly)

#source("./function/calculate_AI.R")
#source("./function/Bruteforce_RI_RA.R")

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
  output$plot <- renderPlotly({
    # Check if bruteforceResults is NULL or not available
    req(bruteforceResults())
    CAmin <- processedInputs()$CAmin
    CAmax <- processedInputs()$CAmax
    df_result3 <- bruteforceResults()  # This will be re-executed only if inputs change
    # Generate the plot with plot_ly
    plot_ly(
      data = df_result3,
      x = ~x, y = ~y,
      type = "scatter",
      mode = "markers",
      alpha = 0.8,
      size = 1.8
    ) |>
      add_markers(x = rep(30:45, each = 21), y = square_y <- rep(5:25, times = 16), 
                  color = I("#F5CF36"),alpha = 0.8,
                  size = 1.8)|>
      add_segments(x = 29.5, xend = 45.5, y = CAmax + 0.5, yend = CAmax + 0.5, 
                   line = list(color = "black", dash = "dash", width = 1.5)) |>
      add_segments(x = 29.5, xend = 45.5, y = CAmin - 0.5, yend = CAmin - 0.5, 
                   line = list(color = "black", dash = "dash", width = 1.5)) |>
      add_segments(x = 29.5, xend = 29.5, y = CAmin - 0.5, yend = CAmax + 0.5,
                   line = list(color = "black", dash = "dash", width = 1.5)) |>
      add_segments(x = 45.5, xend = 45.5, y = CAmin - 0.5, yend = CAmax + 0.5, 
                   line = list(color = "black", dash = "dash", width = 1)) |>
    
      layout(
        xaxis = list(title = "Inclination (°)", range = c(20, 55), showgrid = FALSE),
        yaxis = list(title = "Anteversion (°)", range = c(0, 40), showgrid = FALSE)
      )
   
  })
  # Render text output
  output$text_message1 <- renderText({ 
    text_message1 <- processedInputs()$text_message1
    print(text_message1)})
  
  output$text_message2 <- renderText({ 
    text_message2 <- processedInputs()$text_message2
    print(text_message2)})
}
