source("helpers/helpers.R")

# Constants for text placement
TEXT_X_OFFSET <- 0.55
DURATION_Y_OFFSET <- 0.22
CONVEXITY_Y_OFFSET <- 0.08

bondPlot = function(c, n, f, r, rN) {
  # c  = bond coupon in %
  # n  = time to maturity in years
  # f  = frequency of payments per year
  # r  = current interest rate
  # rN = new interest rate (to see convexity effect)
  
  # Plot bond price as a function of yield
  yields <- seq(0.02, 0.5, by = 0.01)
  nominal_price <- bond_price(c, n, f, yields)
  op <- par(mar = c(6, 4, 4.5, 4) + 0.5)
  on.exit(par(op)) # ensure reset on exit, even on error
  plot(
    yields,
    nominal_price,
    type = "l",
    xlim = c(0, 0.5),
    axes = F,
    xlab = NA,
    ylab = NA
  )
  title(main = "Bond price and risk", line = 4)
  
  
  # calculate the gradient for tangent line
  myenv <- new.env()
  assign("r", r, envir = myenv)
  drv <- numericDeriv(quote(bond_price(c, n, f, r)), c("r"), myenv)
  
  # draw tangent line
  abline(
    a = (c(attr(drv, "gradient") * (0 - r)) + drv[1]),
    b = attr(drv, "gradient"),
    col = "green"
  )
  
  points(r, bond_price(c, n, f, r), col = "red", pch = 19)
  lines(
    c(r, r),
    c(0, bond_price(c, n, f, r)),
    col = "red",
    lty = 3,
    lwd = 2
  )
  lines(
    c(0, r),
    c(bond_price(c, n, f, r), bond_price(c, n, f, r)),
    col =
      "red",
    lty = 3,
    lwd = 2
  )
  
  # new interest rate to see the convexity effect (area in yellow)
  polygon(
    x = c(seq(r, rN, length.out = 10), seq(rN, r, length.out = 10)),
    y = c(bond_price(c, n, f, seq(r, rN, length.out = 10)), rev(
      c(attr(drv, "gradient") * (0 - r) + drv[1]) + c(attr(drv, "gradient")) *
        seq(r, rN, length.out = 10)
    )),
    col = "yellow1"
  )
  points(rN,
         bond_price(c, n, f, r = rN),
         col = "blue",
         pch = 19)
  lines(
    c(rN, rN),
    c(bond_price(c, n, f, r = rN), bond_price(c, n, f, r = min(yields))),
    col =
      "grey",
    lty = 3,
    lwd = 2
  )
  lines(
    c(rN, max(yields)),
    c(bond_price(c, n, f, r = rN), bond_price(c, n, f, r = rN)),
    col =
      "grey",
    lty = 3,
    lwd = 2
  )
  lines(
    c(rN, rN),
    c(0, bond_price(c, n, f, r = rN)),
    col = "blue",
    lty = 3,
    lwd = 2
  )
  lines(
    c(0, rN),
    c(bond_price(c, n, f, r = rN), bond_price(c, n, f, r = rN)),
    col =
      "blue",
    lty = 3,
    lwd = 2
  )
  
  box()
  axis(1, r)
  axis(2, bond_price(c, n, f, r))
  
  # second axis for new interest rate, not to overlap
  axis(3, rN)
  axis(4, bond_price(c, n, f, rN))
  
  # Get plot limits
  usr <- par("usr") # usr = c(xmin, xmax, ymin, ymax)

  # duration and duration effect
  D <- bond_duration(c, n, f, r)
  text(
    usr[1] + TEXT_X_OFFSET * (usr[2] - usr[1]),
    usr[4] - DURATION_Y_OFFSET * (usr[4] - usr[3]),
    paste("Duration=", round(D, 2), "\nMod. Duration=", round(D / (1 + r), 2)),
    pos = 4
  )

  
  # convexity and convexity effect
  konv <- bond_convexity(c, n, f, r)
  text(
    usr[1] + TEXT_X_OFFSET * (usr[2] - usr[1]),
    usr[4] - CONVEXITY_Y_OFFSET * (usr[4] - usr[3]),
    paste(
      "Convexity = ",
      round(konv, 2),
      "\nConv. effect = ",
      round(0.5 * bond_price(c, n, f, r) * konv * (r - rN)^2, 2)
    ),
    pos = 4
  )
  
  # axis names
  mtext(side = 1, "YTM", line = 2)
  mtext(side = 2, "Price in % for selected YTM", line = 2)
  mtext(side = 3, "Market interest rate", line = 2)
  mtext(side = 4, "Market price in %", line = 2)
}
