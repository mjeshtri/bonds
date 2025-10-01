#   Author: Krenar Avdulaj
#   Created: February 19, 2015
#   Last update: October 1, 2025

library(manipulate)

source("bondPlot.R")

manipulate(
  bondPlot(c / 100, t, f = Frequency, r / 100, rN / 100),
  
  # Bond Specification
  c = slider(0.5, 50, step = 0.5, initial = 5, "Coupon rate (%)"),
  t = slider(1, 30, initial = 5, "TTM (Bond Specification)"),
  Frequency = picker(
    "Annually" = 1,
    "Semi-annually" = 2,
    label = "Frequency (Bond Specification)"
  ),
  
  # Simulation Parameters
  r = slider(0.5, 50, step = 0.5, initial = 5, "YTM (%)"),
  rN = slider(
    0.5,
    50,
    step = 0.5,
    initial = 14,
    "New interest rate (%)"
  )
)
