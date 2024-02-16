library(shiny)

fluidPage(
  
  titlePanel("Individualized Cup Replacement"),
  
  sidebarPanel(
    # The initial value of the slider, either a number, a date (class Date), or a date-time (class POSIXt).
    # A length one vector will create a regular slider; 
    # a length two vector will create a double-ended range slider. Must lie between min and max
    
    sliderInput(inputId ='PI', 'Pelvic Incidence (PI)', min=20, max=80,
                 value = 40,step = 1, round=0),
    sliderInput(inputId ='LL', 'Lumbar Lordosis (LL)', min= 0, max=80,
                value = 20,step = 1, round=0),
        
    sliderInput(inputId = "SSstanding", 'Sacral Slop (SS) Standing', min= -10, max=80,
                value = 50,step = 1, round=0),
    sliderInput(inputId ='SSsitting', 'Sacral Slop (SS) Sitting', min= -10, max=80,
                value = 45, step = 1, round=0),
    
    sliderInput(inputId ='FA', 'Femoral Anteversion (FA)', min= 0, max=45,
                value = 0,step = 1, round=0),
    sliderInput(inputId ='Beta', 'Anterior Pelvic Plane Inclination (Beta)', min= -30, max=30,
                value = 0,step = 1, round=0),
    sliderInput(inputId ='d', 'Direction (right = 1, left = -1)', min=-1, max=1,
                value = 1, step = 2, round=0),
    sliderInput(inputId ='ESP', 'Epsilon', min= 1, max=5,
                value = 3, step = 1, round=0),
    
    ),
  
  mainPanel(
    plotOutput(outputId = 'plot')
  )
)