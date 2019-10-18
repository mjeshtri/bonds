#   Author: Krenar Avdulaj
#   19 February 2015
library(manipulate)
source("helpers/helpers.R")

bondP=function(c,n,f,r,rN){
  # c  = bond coupon in %
  # n  = time to maturity in years
  # f  = frequency of payments per year
  # r  = current interest rate
  # rN = new interest rate (to see convexity effect)
  
  # Plot bond price as a function of yield
  yields <- seq(0.02,0.5,by=0.01)
  nominal_price <- bond_price(c,n,f,yields)
  op <- par(mar = c(6,4,4.5,4) + 0.5)
  plot(yields,nominal_price,type="l",xlim=c(0,0.5),axes = F,xlab = NA,ylab = NA)
  title(main="Bond price",line=4)
  

  # calculate the gradient for tanget line
  myenv <- new.env()
  assign("r", r, envir = myenv)
  drv <- numericDeriv(quote(bond_price(c,n,f,r)),c("r"),myenv)

  # draw tangent line
  abline(a=(c(attr(drv,"gradient")*(0-r))+drv[1]),b=attr(drv,"gradient"),col="green")

  points(r,bond_price(c,n,f,r),col="red",pch=19)
  lines(c(r,r),c(0,bond_price(c,n,f,r)), col = "red",lty=3,lwd=2)
  lines(c(0,r),c(bond_price(c,n,f,r),bond_price(c,n,f,r)), col =
          "red",lty=3,lwd=2)

  # new interest rate to see the convexity effect (area in yellow)
  polygon(x=c(seq(r,rN,length.out=10),seq(rN,r,length.out=10)),
          y=c(bond_price(c,n,f,seq(r,rN,length.out=10)),rev(c(attr(drv,"gradient")*(0-r)+drv[1])+c(attr(drv,"gradient"))*seq(r,rN,length.out=10))),
          col="yellow1")
  points(rN,bond_price(c,n,f,r=rN),col="blue",pch=19)
  lines(c(rN,rN),c(bond_price(c,n,f,r=rN),bond_price(c,n,f,r=min(yields))), col =
          "grey",lty=3,lwd=2)
  lines(c(rN,max(yields)),c(bond_price(c,n,f,r=rN),bond_price(c,n,f,r=rN)), col =
          "grey",lty=3,lwd=2)
  lines(c(rN,rN),c(0,bond_price(c,n,f,r=rN)), col = "blue",lty=3,lwd=2)
  lines(c(0,rN),c(bond_price(c,n,f,r=rN),bond_price(c,n,f,r=rN)), col =
          "blue",lty=3,lwd=2)

  box()
  axis(1,r)
  axis(2,bond_price(c,n,f,r))

  # second axis for new interest rate, not to overlap
  axis(3,rN)
  axis(4,bond_price(c,n,f,rN))

  # duration and duration effect
  D <-bond_duration(c,n,f,r)
  text(0.15,100,paste("Duration=",round(D,digits=2),"\nMod. Duration=",round(D/(1+r),digits=2)),pos=4)


  # calculate convexity  and convexity effect (are in yellow)
  konv <- bond_convexity(c, n, f, r)
  text(0.32,100,paste("Convexity = ",round(konv,digits=2),"\nConv. effect = ",round(0.5*bond_price(c,n,f,r)*konv*(r-rN)^2,digits=2)),pos=4)


  # axis names
  mtext(side = 1, "Yield", line = 2)
  mtext(side = 2, "Price in %", line = 2)
  mtext(side = 3, "New interest rate", line = 2)
  mtext(side= 4,"New price in %",  line = 2)
}

manipulate(bondP(c,t,f=Frequency,r,rN),
           c=slider(.02,0.5,step=.01,initial=.05,"Coupon rate"),
           t=slider(1,30,initial=5,"TTM"),
           r=slider(.02,0.5,step=.01,initial=.05,"Yield"),
           rN=slider(.02,0.5,step=.01,initial=.14,"New interest rate"),
           Frequency=picker("Annually"=1,"Semi-annually"=2)
)
