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
    df_result <- message_CA_PT_AI(input$PI, input$LL, input$SSstanding,
                                  input$SSsitting, input$Beta, input$FA)
    # Extract values
    list(
      CAmin = df_result[which(df_result$Variables == 'CAmin'), 2],
      CAmax = df_result[which(df_result$Variables == 'CAmax'), 2],
      PT = df_result[which(df_result$Variables == 'PT'), 2],
      AI = df_result[which(df_result$Variables == 'AI'), 2]
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
  output$plot <- renderPlot({
    # Check if bruteforceResults is NULL or not available
    req(bruteforceResults())
    df_result <- bruteforceResults()  # This will be re-executed only if inputs change
    
    # Generate the plot with plot_ly
    plot_ly(
      data = df_result,
      x = ~x, y = ~y,
      type = "scatter",
      mode = "markers",
      alpha = 0.5
    ) %>%
      layout(
        xaxis = list(title = "Inclination (°)", range = c(20, 55), showgrid = FALSE),
        yaxis = list(title = "Anteversion (°)", range = c(0, 40), showgrid = FALSE)
      )
  }, height = 700)
}
