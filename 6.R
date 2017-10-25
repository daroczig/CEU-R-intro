library(shiny)
library(ggplot2)

## define the User Interface
ui <- shinyUI(fluidPage(

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

## define the back-end
server <- shinyServer(function(input, output) {

    ## this is the default tab in the main tab
    output$ggplot <- renderPlot({
        ggplot(mtcars, aes_string(x = input$var1, y = input$var2, col = input$col)) +
            geom_point() +
            geom_smooth(method = 'lm', formula = y ~ poly(x, as.numeric(input$poly)),
                        se = input$se)
    })

    output$model <- renderPrint({
        fit <- lm(mtcars[, input$var2] ~ poly(mtcars[, input$var1], input$poly))
        summary(fit)
    })

    output$coeff <- renderTable({
        fit <- lm(mtcars[, input$var2] ~ poly(mtcars[, input$var1], input$poly))
        summary(fit)$coeff
    })

})

## start the Shiny app
shinyApp(ui = ui, server = server)
