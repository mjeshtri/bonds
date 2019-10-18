bond_price <- function(coupon, n, f, r, nominal = TRUE, face_value = 100, tau = 0){
  # coupon = bond coupon in %
  # n      = time to maturity in years
  # f      = frequency of payments per year
  # r      = current interest rate
  # tau    = time since last dividend tau(0, 1)
  if(nominal){
    coupon <- coupon * face_value
  } else {
    face_value <- 100 # ensure price is always 100 when price in percentage is calculated
  }
  coupon/f*(1-(1/(1+r/f)^(n*f)))/(r/f)+face_value/(1 + r/f)^(f*n)
}

time_weighted_bond_cf <- function(c, n, f, r, face_value = 100){
  # calulate time weighted cash flows from a bond
  coupon <- c * face_value
  t<- seq(1,n*f)

  out <- coupon * t/ (1 + r/f) ^ t
  out[length(t)] <-  out[length(t)] + face_value*f*n / (1 + r/f) ^ (f*n)
  return(out)
}

bond_duration <- function(c, n, f, r, face_value = 100){
  Pt <- sum(time_weighted_bond_cf(c, n, f, r, face_value))
  Pt/bond_price(c, n, f, r, face_value)
}

bond_convexity <- function(c,n,f,r, face_value = 100){
  ii <- seq(1:n*f)
  coupon <- c * face_value
  coupons <- rep(coupon,n*f)
  coupons[n*f] <-coupons[n*f] + face_value
  sum((ii*(ii+1)*coupons)/(bond_price(c,n,f,r, face_value)*(1+r)^(ii+2)))
}

bond_price_tau <-function(c, n, r, face_value = 100, tau = 0){
  if((tau < 0) || (tau > 1)) stop("'tau' must be >= 0 and <=1")
  coupon <- c * face_value
  t<- seq(1,n)
  sum(coupon / (1 + r) ^ (t-tau)) + face_value / (1 + r) ^ (n-tau)
}