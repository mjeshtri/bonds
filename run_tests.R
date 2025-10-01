library(testthat)

# Dynamically set working directory to the script's location
get_script_path <- function() {
  # For Rscript or source()
  if (exists("ofile", where = sys.frame(1)) && !is.null(sys.frame(1)$ofile)) {
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

source("helpers/helpers.R")

test_results <- test_dir("helpers", reporter = "summary")
