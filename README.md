# Bond price sensitivity

This repo offers an interactive way for studying the bond price sensitivity as a function of:

- coupon rate
- time-to-maturity (TTM)
- yield

# Requirements

This code is tested to run correctly with

- R version 3.6.1 (2019-07-05)
- RStudio Version 1.2.1335
  Older versions could also work.
  Two packages are direct dependencies:
  - `manipulate` - for interactive plot
  - `testthat` - in case you want to run the Unit Tests

The latest R version can be downloaded from [here](https://www.r-project.org/), while the latest RStudio from [here](https://rstudio.com/products/rstudio/download/?utm_source=downloadrstudio&utm_medium=Site&utm_campaign=home-hero-cta). 
# How to use

Sourcing or running `interactive_bonds.R` should generate the interactive plot like this:

![Bond price](screenshots/picture.png)

The example is completly theoretical as it assumes that at time when when the bond with coupon rate `c` (and selected TTM and coupon frequency) is issued, we select the required Yield. If the yield matches the coupon rate the price matches the face value (expresed as percentage) and there is no risk. However, if some new interest rate is applied ( see x-axes on top), we can observe the new theoretical price (in second y- axis). In addition the script calculates the Macaulay’s duration, modified duration, convexity and convexity effect.
