#####same as v1, only makes the variance and slope different
command.args = commandArgs(trailingOnly = TRUE) 
n = as.numeric(command.args[1])
##100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400 intotal 4
# d1 = as.numeric(command.args[2])##0.1,1,2,3,4 in total 5
# d2 = as.numeric(command.args[3])##3,4,5 in total 3


library(mvtnorm)
# # 
# # 
# n=1600
d1=3.2
d2=3.2





# qq11 = lm(log(Y)-log(X)~1)$coefficients
# 


# # 
# qq11 = matrix(rnorm(50),nrow = 5)
# 
# bb11=c(1,10,100,-100,-10)+qq11
# # dd11 = rowMeans(bb11)
# bb11-300


delta = n^(-d1/8)
delta2 = n^(-d2/8)

reptime = 2000

beta0 = c(0.3,1)
sd= 1
res1 = rep(0,reptime)

Boottime = 500
# n^(-6/8)
resultraw = c()

set.seed(123)

for (rr in 1:reptime) {
  
  # X =rep(0,n)
  
  X00 =rmvnorm(2*n, mean=rep(0,2), sigma=diag(c(1,1)))
  u1 = rnorm(2*n,0,sd)
  u2 = rnorm(2*n,0,sd)
  Y00 = X00%*%beta0+u1
  Z00 = X00%*%beta0+u2
  
  X0 = X00[1:n,]
  Y0 = Y00[1:n,,drop=F]
  Z0 = Z00[1:n,,drop=F]
  
  X = X00[(1+n):(2*n),]
  Y = Y00[(1+n):(2*n),,drop=F]
  Z = Z00[(1+n):(2*n),,drop=F]
  
  
  
  
  # beta_hat1 = solve(t(X0)%*%X0)%*%t(X0)%*%Y0
  # beta_hat2 = solve(t(X0)%*%X0)%*%t(X0)%*%Z0
  # est_err1 = sqrt(n)*(beta_hat1-beta0)
  # est_err2 = sqrt(n)*(beta_hat2-beta0)
  # beta1 =   beta_hat1
  # beta2 = beta_hat2 
  
  est_err1 = delta*beta0
  est_err2 = delta2*beta0
  beta1 = beta0 +est_err1
  beta2 = beta0 +est_err2
  ####Y matrix
  gmatrix =exp( -abs(outer(as.vector(Y),as.vector(Y),"-")))  
  gmatrix_Y = gmatrix
  Y_row = matrix(rep(Y,n),ncol = n)
  hat_X_col = t(matrix(rep((X%*%beta1),n),ncol = n))
  temp_Y = Y_row-hat_X_col
  
  EY = exp(1/2)*exp(-temp_Y)*(1-pnorm((-temp_Y+1)))+exp(1/2)*exp(temp_Y)*(1-pnorm((temp_Y+1)))
  
  temp_X = outer(as.vector(X%*%beta1),as.vector(X%*%beta1),"-")
  res_matrix = exp(1)*exp(-temp_X)*(1-pnorm(  (-temp_X/sqrt(2)+sqrt(2))  ))+ exp(1)*exp(temp_X)*(1-pnorm(  (temp_X/sqrt(2)+sqrt(2))  ))
  res_matrix_Y=res_matrix
  
  ####Z matrix
  gmatrix =exp( -abs(outer(as.vector(Z),as.vector(Z),"-")))  
  gmatrix_Z = gmatrix
  Z_row = matrix(rep(Z,n),ncol = n)
  hat_X_col = t(matrix(rep((X%*%beta2),n),ncol = n))
  temp_Z = Z_row-hat_X_col
  
  EZ = exp(1/2)*exp(-temp_Z)*(1-pnorm((-temp_Z+1)))+exp(1/2)*exp(temp_Z)*(1-pnorm((temp_Z+1)))
  
  temp_X = outer(as.vector(X%*%beta2),as.vector(X%*%beta2),"-")
  res_matrix = exp(1)*exp(-temp_X)*(1-pnorm(  (-temp_X/sqrt(2)+sqrt(2))  ))+ exp(1)*exp(temp_X)*(1-pnorm(  (temp_X/sqrt(2)+sqrt(2))  ))
  
  res_matrix_Z=res_matrix
  
  QQ_matrix  = EY*EZ
  
  F_matrix = (gmatrix_Y*gmatrix_Z-QQ_matrix-t(QQ_matrix)+res_matrix_Y*res_matrix_Z)*exp( -as.matrix(dist(X,method = "manhattan")))
  FF_matrix = F_matrix-diag(diag(F_matrix))
  
  stat = sum(FF_matrix)/((n-1))
  
  
  boottemp = rep(0,Boottime)
  
  eboot=matrix(rnorm(n*Boottime),nrow = Boottime)
  
  for (bb in 1:Boottime) {
    bootmatrix = FF_matrix*(eboot[bb,]%*%t(eboot[bb,]))
    boottemp[bb]  = sum( bootmatrix)/((n-1))
  }
  
  
  res1[rr] = mean(boottemp>stat)
  
}

# qq11 = as.matrix(dist(X,method = "manhattan"))


# 
# mean(res1[1:680]<0.05)



resultraw = rbind(resultraw,c(n,d1,d2,res1))

write.csv(resultraw,paste0("./result/no_robust_case_size_n",n,"_delta",d1,"_delta2",d2,"_v5.csv"),row.names = F)




















