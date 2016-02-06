library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  output$plot <- renderPlot({

   plot(mtcars[, input$var1], mtcars[, input$var2], pch = 19, col = mtcars[, input$col] + 1)
   fit <- lm(mtcars[, input$var2] ~ poly(mtcars[, input$var1], input$poly))
   points(mtcars[, input$var1], predict(fit))

  })
  
  output$ggplot <- renderPlot({
    
    ggplot(mtcars, aes_string(x = input$var1, y = input$var2, col = input$col)) + geom_point() +
      geom_smooth(method = 'lm', formula = y ~ poly(x, as.numeric(input$poly)), se = FALSE)
    
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
