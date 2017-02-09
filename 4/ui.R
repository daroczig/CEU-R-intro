library(shiny)

## boilerplate
shinyUI(fluidPage(
  
  ## title of the app
  titlePanel("The great mtcars analysis engine"),
  
  ## setting up the layout of the app: we will use a sidebar + a main panel
  sidebarLayout(
    
    sidebarPanel(
      selectInput('var1', 'X', names(mtcars), selected = 'wt'),
      selectInput('var2', 'Y', names(mtcars), selected = 'mpg'),      
      sliderInput("poly",
                  "Polynomial:", min = 1, max = 16, value = 1),
      selectInput('col', 'Color', c('gear', 'am', 'cyl')),
      checkboxInput('se', 'Conf intervals?')
    ),
    
    mainPanel( 
       tabsetPanel(
         tabPanel("gglot", plotOutput("ggplot")),
         tabPanel("Model", verbatimTextOutput("model")),
         tabPanel("Coefficients", htmlOutput("coeff"))
       )
    )
  )
))
