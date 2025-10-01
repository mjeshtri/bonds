#   Author: Krenar Avdulaj
#   19 February 2015
#   Last update: 1 October 2025

library(manipulate)

# Dynamically set working directory to the script's location
get_script_path <- function() {
  # For Rscript or source()
  if (!is.null(sys.frame(1)$ofile)) {
    return(normalizePath(sys.frame(1)$ofile))
  }
  # For RStudio
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {
    return(normalizePath(rstudioapi::getActiveDocumentContext()$path))
  }
  # Fallback: current working directory
  return(NULL)
}

script_path <- get_script_path()
if (!is.null(script_path)) {
  setwd(dirname(script_path))
}

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
