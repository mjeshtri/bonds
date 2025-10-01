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
          "Market interest rate (%)",
          min = 0.5,
          max = 50,
          value = 14,
          step = 0.5
        )
      )
    ),
    mainPanel(plotOutput("bondPlot", height = "65vh"))
  ),
  helpText(
    HTML(
      "<div style='background:#f8f9fa; border:1px solid #e3e3e3; border-radius:8px; padding:16px; margin-top:16px;'>
      <h4 style='color:#2c3e50; margin-top:0;'><b>Plain Vanilla Bond Specification</b></h4>
      <ul style='margin-bottom:16px;'>
        <li>💵 <b>Face value:</b> Automatically set at 100%, can be scaled to any real face value.</li>
        <li>💲 <b>Coupon rate:</b> Set the bond's coupon rate.</li>
        <li>⏳ <b>TTM:</b> Set the time to maturity (in years).</li>
        <li>📅 <b>Frequency:</b> Choose annual or semi-annual payments.</li>
      </ul>
      <h4 style='color:#2c3e50;'><b>Simulate Change in Market Interest Rates or Change in YTM</b></h4>
      <ul>
        <li>📈 <b>Market interest rate:</b> Simulate a change in market rates and observe the impact on bond pricing and risk.</li>
        <li>🎯 <b>YTM:</b> Set your yield to maturity target. This is the internal rate of return required given the bond characteristics. This will give you the bond price to achieve this target.</li>
      </ul>
      <p style='margin-top:16px;'>The plot will update automatically as you change the inputs.<br>
      The code is available at <a href='https://github.com/mjeshtri/bonds' target='_blank'>https://github.com/mjeshtri/bonds</a></p>
    </div>"
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