library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
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
