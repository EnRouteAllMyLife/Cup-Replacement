library(shiny)
library(plotly)
library(tidyverse)
library(shinythemes)
#library(shinydashboard)
fluidPage(
  theme = shinytheme("lumen"),
  titlePanel("Individualized Cup Replacement"),
  a("The algorithm was designed for preoperative planning in navigation or robot assisted surgery. It could also be used for preoperative evaluation to identify at risk patients with pelvic abnormal mobility."),
  br(),
  br(),
  fluidRow(
    column(3,
           wellPanel(
             h4("Basic Inputs"),
             sliderInput(inputId ='PI', 'Pelvic Incidence (PI)', min=20, max=80,
                 value = 50,step = 1, round=0),
             sliderInput(inputId ='LL', 'Lumbar Lordosis (LL) Standing', min= 0, max=80,
                value = 20,step = 1, round=0),
             sliderInput(inputId = "SSstanding", 'Sacral Slop (SS) Standing', min= -10, max=80,
                value = 50,step = 1, round=0),
             sliderInput(inputId ='SSsitting', 'Sacral Slop (SS) Sitting', min= -10, max=80,
                value = 20, step = 1, round=0)),
           wellPanel(
             h4("Adjusting Inputs"),
             sliderInput(inputId ='FA', 'Femoral Anteversion (FA)', min= 0, max=45,
                value = 0,step = 1, round=0),
             sliderInput(inputId ='Beta', 'Anterior Pelvic Plane Inclination (Beta)', min= -30, max=30,
                value = 0,step = 1, round=0),
             sliderInput(inputId ='d', 'Direction (right = 1, left = -1)', min=-1, max=1,
                value = 1, step = 2, round=0),
             sliderInput(inputId ='ESP', 'Epsilon', min= 1, max=5,
                value = 3, step = 1, round=0))
     ),
  mainPanel(
      tabsetPanel(
      tabPanel("Plot",
              
               wellPanel(
                 textOutput(outputId = "text_message1"),
                 textOutput(outputId = "text_message2")
               ),
               plotlyOutput(outputId = 'plot',height = '800px')),
      tabPanel("Details",
               h3("Intersection Safe Zone"),
               h4("Details on inclination, anteversion combination"),
               DT::dataTableOutput("table")
               ),
      tabPanel("Dictionary",
               h4("Standard lateral films in standing and relaxed sitting positions should be acquired. The films should include upper endplate of L1 down to proximal femur. The following parameters could be measured using the two films."),
               DT::datatable(data.frame(
                 Variable = c("Pelvic Incidence",
                              "Lumbar Lordosis Standing",
                              "Sacral Slop Standing",
                              "Sacral Slop Sitting",
                              "Femoral Anteversion",
                              "Anterior Pelvic Plane Inclination",
                              "Direction",
                              "Epsilon"
                              ),
                 Abbreviation = c("PI",
                                  "LL in standing position",
                                  "SS in standing position",
                                  "SS in sitting position",
                                  "FA",
                                  "Beta",
                                  "d",
                                  "Eps"
                                  ),
                 Description = c("An angle between a line perpendicular to upper endplate of S1 and a line connecting the middle point the upper endplate of S1 and the average of the femoral rotation centers.",
                                 "An angle between the upper endplate of L1 and the lower endplate of L5 in standing position.",
                                 "An angle between the horizontal line and the upper endplate of S1 in standing position.",
                                 "An angle between the horizontal line and the upper endplate of S1in sitting position.",
                                 "An angle between femoral implant neck and a line connecting posterior surface of femoral condyles.",
                                 "An angle between anterior pelvic plane and perpendicular line.",
                                 "",
                                 "The width of the blue ribbon, aka the functional safe zone "))))
)
)
)
)