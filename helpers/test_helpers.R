library(testthat) 
source("helpers.R")

test_that("Test bond_price()",{
  c <- 0.1
  n <- 5 # number of years
  f <- 1 # frequency of coupons per year
  yields <- seq(0.02,0.5,by=0.01)

  nominal_prices <- c(137.70768,132.05795 ,126.71093 ,121.64738 ,116.84946 ,112.30059, 107.98542 ,103.88965, 100.00000 , 96.30410 , 92.79045 , 89.44831  ,86.26768 , 83.23922,  80.35424 , 77.60458 , 74.98263,
                      72.48129,  70.09388 , 67.81417 , 65.63632 , 63.55485 , 61.56462 , 59.66080 , 57.83887 , 56.09456,  54.42389,  52.82308 , 51.28860 , 49.81712 , 48.40549 , 47.05075 , 45.75012 , 44.50096,
                      43.30080 , 42.14729 , 41.03820 , 39.97146,  38.94508 , 37.95720,  37.00603 , 36.08991 , 35.20725,  34.35654,  33.53637 , 32.74537,  31.98228 , 31.24586 , 30.53498)
  percentage_prices <- c(91.04443, 86.71885, 82.63789, 78.78556, 75.14705, 71.70864, 68.45759, 65.38210, 62.47121, 59.71472, 57.10316, 54.62772, 52.28017, 50.05289, 47.93873, 45.93105, 44.02364, 42.21070, 40.48682,
                         38.84693, 37.28629, 35.80047, 34.38531, 33.03693, 31.75167, 30.52610, 29.35703, 28.24143, 27.17646, 26.15947, 25.18796, 24.25955, 23.37204, 22.52335, 21.71149, 20.93462, 20.19100, 19.47896,
                         18.79696, 18.14353, 17.51727, 16.91688, 16.34113, 15.78882, 15.25887, 14.75022, 14.26187, 13.79289, 13.34239)
  for(i in 1:length(yields)){
    expect_equal(bond_price(c, n, f, yields[i], nominal = TRUE), nominal_prices[i],tolerance=1e-4)
    expect_equal(bond_price(c, n, f, yields[i], nominal = FALSE), percentage_prices[i],tolerance=1e-4)
    expect_equal(bond_price(c, n, f, yields[i], nominal = FALSE, face_value = 250), percentage_prices[i],tolerance=1e-4)
  }
})

test_that("Test time_weighted_bond_cf()",{
  c <- 0.1
  n <- 5 # number of years
  f <- 1 # frequency of coupons per year
  r <- 0.15 # discount rate

  expected_result <- c(8.695652,  15.122873,  19.725487,  22.870130, 273.447204)
  expect_equal(time_weighted_bond_cf(c,n,f,r),expected_result,tolerance=1e-4)
})


test_that("Test bond_duration()",{
  c <- 0.08
  n <- 5 # number of years
  f <- 1 # frequency of coupons per year
  r <- 0.1 # discount rate

  expected_result <- 4.281412
  expect_equal(bond_duration(c, n, f, r), expected_result, tolerance=1e-4)
})

test_that("Test bond_convexity()",{
  c <- 0.08
  n <- 5 # number of years
  f <- 1 # frequency of coupons per year
  r <- 0.1 # discount rate

  expected_result <- 20.09732
  expect_equal(bond_convexity(c, n, f, r), expected_result, tolerance=1e-4)
})

test_that("Test bond_price_tau()",{
  c <- 0.1 # coupon rate
  n <- 5   # number of years
  r <- 0.12 # discount rate
  face_value <- 1000
  days_since_last_dividend <- 68
  settlement_days <- 3
  tau <- (days_since_last_dividend + settlement_days) / 360

  expected_result <- 948.8775
  expect_equal(bond_price_tau(c, n, r, face_value, tau), expected_result, tolerance=1e-4)
})