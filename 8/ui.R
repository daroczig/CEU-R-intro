library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("poly",
                  "Polynomial:",
                  min = 1,
                  max = 16,
                  value = 2),
      
      
      selectInput('var1', 'X', names(mtcars), selected = 'wt'),
      selectInput('var2', 'Y', names(mtcars), selected = 'mpg'),
      selectInput('col', 'Color', c('gear', 'am', 'cyl'))
    ),
    
    

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot")),
        tabPanel("gglot", plotOutput("ggplot")),
        tabPanel("Model", verbatimTextOutput("model")),
        tabPanel("Coefficients", htmlOutput("coeff"))
      )
    )
  )
))
