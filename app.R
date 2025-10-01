# This code is used only for publishing the application in shinyapp.io
library(shiny)

source("bondPlot.R")

ui <- fluidPage(
  titlePanel("Plain Vanilla Bond - Interactive Plot"),
  sidebarLayout(
    sidebarPanel(
      tags$div(
        tags$strong("Bond Specification Parameters"),
        sliderInput(
          "c",
          "Coupon rate (%)",
          min = 0.5,
          max = 50,
          value = 5,
          step = 0.5
        ),
        sliderInput(
          "t",
          "TTM",
          min = 1,
          max = 30,
          value = 5
        ),
        selectInput(
          "Frequency",
          "Frequency",
          choices = c("Annually" = 1, "Semi-annually" = 2),
          selected = 1
        )
      ),
      tags$hr(),
      tags$div(
        tags$strong("Simulation Parameters"),
        sliderInput(
          "r",
          "YTM (%)",
          min = 0.5,
          max = 50,
          value = 5,
          step = 0.5
        ),
        sliderInput(
          "rN",
          "New interest rate (%)",
          min = 0.5,
          max = 50,
          value = 14,
          step = 0.5
        )
      )
    ),
    mainPanel(plotOutput("bondPlot", height = "75vh"))
  ),
  helpText(
    HTML(
      "<b>Plain Vanilla Bond Specification</b>
      <ul>
        <li>Face value: it is automatically set at 100%, this way it can be scaled at whatever real face value you want.</li>
        <li>Coupon rate: Set the bond's coupon rate.</li>
        <li>TTM: Set the time to maturity (in years).</li>
        <li>Frequency: Choose annual or semi-annual payments.</li>
      </ul>
      <b>Simulate Change in Market Interest Rates or Change in YTM</b>
      <ul>
        <li>New market interest rate: Simulate a change in market rates and observe the impact on (market) bond pricing and risk.</li>
        <li>YTM: Set your yield to maturity target. This is the internal rate of return which you require given the bond characteristics. This will give you the bond price which you should buy to achieve this target.</li>
      </ul>
      <p>The plot will update automatically as you change the inputs. We assume the bond specification, market interest rate and YTM for the pricing and risk analysis. Any exogenous factors are not considered in this simple model.<br>
      The code is available at <a href='https://github.com/mjeshtri/bonds' target='_blank'>https://github.com/mjeshtri/bonds</a></p>"
    )
  )
)

server <- function(input, output, session) {
  output$bondPlot <- renderPlot({
    bondPlot(
      c = input$c / 100,
      n = input$t,
      f = as.numeric(input$Frequency),
      r = input$r / 100,
      rN = input$rN / 100
    )
  })
}

shinyApp(ui, server)