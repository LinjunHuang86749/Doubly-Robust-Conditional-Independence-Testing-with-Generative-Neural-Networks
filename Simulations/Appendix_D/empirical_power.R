#####same as v1, only makes the variance and slope different
command.args = commandArgs(trailingOnly = TRUE) 
# n = as.numeric(command.args[1])#1000,1500
pp = as.numeric(command.args[1])#
#0.000, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 0.007, 0.008, 0.009, 0.010, 0.011, 0.012, 0.013, 0.014
#0.015, 0.016, 0.017, 0.018, 0.019, 0.020, 0.021, 0.022, 0.023, 0.024, 0.025, 0.026, 0.027, 0.028, 0.029
#0.030, 0.031, 0.032, 0.033, 0.034, 0.035, 0.036, 0.037, 0.038, 0.039, 0.040, 0.041, 0.042, 0.043, 0.044
#0.045, 0.046, 0.047, 0.048, 0.049, 0.050, 0.051, 0.052, 0.053, 0.054, 0.055, 0.056, 0.057, 0.058, 0.059
#0.060, 0.061, 0.062, 0.063, 0.064, 0.065, 0.066, 0.067, 0.068, 0.069, 0.070, 0.071, 0.072, 0.073, 0.074
#0.075, 0.076, 0.077, 0.078, 0.079, 0.080, 0.081, 0.082, 0.083, 0.084, 0.085, 0.086, 0.087, 0.088, 0.089
#0.090, 0.091, 0.092, 0.093, 0.094, 0.095, 0.096, 0.097, 0.098, 0.099, 0.100, 0.101, 0.102, 0.103, 0.104
#0.105, 0.106, 0.107, 0.108, 0.109, 0.110, 0.111, 0.112, 0.113, 0.114, 0.115, 0.116, 0.117, 0.118, 0.119

library(mvtnorm)
# # 
# # 
# n=1600
n=1000

# pp=0.001
# # 

# pp=0.11

# qq11 = lm(log(Y)-log(X)~1)$coefficients
# 


# # 
# qq11 = matrix(rnorm(50),nrow = 5)
# 
# bb11=c(1,10,100,-100,-10)+qq11
# # dd11 = rowMeans(bb11)
# bb11-300


# delta = n^(-d1/8)
# delta2 = n^(-d2/8)

reptime = 2000
# 
# beta0 = c(0.3,1)
sd= 1
res10 = rep(0,reptime)
res1 = rep(0,reptime)
Boottime = 500
# n^(-6/8)
resultraw0 = c()
resultraw = c()
set.seed(123)

for (rr in 1:reptime) {
  
  # X =rep(0,n)
  
  X =rnorm(n,0,sd)
  u1 = rnorm(n,0,sd)
  u2 = rnorm(n,0,sd)
  ber1 = rbinom(n,1,pp)
  u3 = ber1*u1+(1-ber1)*u2
  Y = X+u1
  Z = X+u3
  
  # X0 = X00[1:n,]
  # Y0 = Y00[1:n,,drop=F]
  # Z0 = Z00[1:n,,drop=F]
  # 
  # X = X00[(1+n):(2*n),]
  # Y = Y00[(1+n):(2*n),,drop=F]
  # Z = Z00[(1+n):(2*n),,drop=F]
  
  
  # beta_hat1 = solve(t(X0)%*%X0)%*%t(X0)%*%Y0
  # beta_hat2 = solve(t(X0)%*%X0)%*%t(X0)%*%Z0
  # est_err1 = sqrt(n)*(beta_hat1-beta0)
  # est_err2 = sqrt(n)*(beta_hat2-beta0)
  # beta1 =   beta_hat1
  # beta2 = beta_hat2 
  
  # est_err1 = delta*beta0
  # est_err2 = delta2*beta0
  # beta1 = beta0 #+est_err1
  # beta2 = beta0 #+est_err2
  ####Y matrix
  gmatrix =exp( -abs(outer(as.vector(Y),as.vector(Y),"-")))  
  gmatrix_Y = gmatrix
  Y_row = matrix(rep(Y,n),ncol = n)
  hat_X_col = t(matrix(rep((X),n),ncol = n))
  temp_Y = Y_row-hat_X_col
  
  EY = exp(1/2)*exp(-temp_Y)*(1-pnorm((-temp_Y+1)))+exp(1/2)*exp(temp_Y)*(1-pnorm((temp_Y+1)))
  
  temp_X = outer(as.vector(X),as.vector(X),"-")
  res_matrix = exp(1)*exp(-temp_X)*(1-pnorm(  (-temp_X/sqrt(2)+sqrt(2))  ))+ exp(1)*exp(temp_X)*(1-pnorm(  (temp_X/sqrt(2)+sqrt(2))  ))
  res_matrix_Y=res_matrix

  ####Z matrix
  gmatrix =exp( -abs(outer(as.vector(Z),as.vector(Z),"-")))  
  gmatrix_Z = gmatrix
  Z_row = matrix(rep(Z,n),ncol = n)
  hat_X_col = t(matrix(rep((X),n),ncol = n))
  temp_Z = Z_row-hat_X_col
  
  EZ = exp(1/2)*exp(-temp_Z)*(1-pnorm((-temp_Z+1)))+exp(1/2)*exp(temp_Z)*(1-pnorm((temp_Z+1)))
  
  temp_X = outer(as.vector(X),as.vector(X),"-")
  res_matrix = exp(1)*exp(-temp_X)*(1-pnorm(  (-temp_X/sqrt(2)+sqrt(2))  ))+ exp(1)*exp(temp_X)*(1-pnorm(  (temp_X/sqrt(2)+sqrt(2))  ))
  
  res_matrix_Z=res_matrix
  
  QQ_matrix  = EY*EZ
  
  F_matrix = (gmatrix_Y*gmatrix_Z-QQ_matrix-t(QQ_matrix)+res_matrix_Y*res_matrix_Z)*exp( -as.matrix(dist(X,method = "manhattan")))
  FF_matrix0 = F_matrix-diag(diag(F_matrix))
  ####T^ast_0
   stat0 = sum(FF_matrix0)/((n-1))
   ####T^ast
  U_y =   gmatrix_Y-EY-t(EY)+res_matrix_Y
  U_z =   gmatrix_Z-EZ-t(EZ)+res_matrix_Z  
  
  F_matrix =U_y*U_z*exp( -as.matrix(dist(X,method = "manhattan")))
  FF_matrix = F_matrix-diag(diag(F_matrix))
   
  stat = sum(FF_matrix)/((n-1))
   
   
   
   boottemp0 = rep(0,Boottime)
   boottemp = rep(0,Boottime)
   eboot=matrix(rnorm(n*Boottime),nrow = Boottime)
   
   for (bb in 1:Boottime) {
     bootmatrix0 = FF_matrix0*(eboot[bb,]%*%t(eboot[bb,]))
     bootmatrix = FF_matrix*(eboot[bb,]%*%t(eboot[bb,]))
     boottemp0[bb]  = sum( bootmatrix0)/((n-1))
     boottemp[bb]  = sum( bootmatrix)/((n-1))
   }
   
   res10[rr] = mean(boottemp0>stat0)
   res1[rr] = mean(boottemp>stat)
  
}

# qq11 = as.matrix(dist(X,method = "manhattan"))


# 
# mean(res1[1:680]<0.05)



resultraw0 = rbind(resultraw0,c(n,pp,res10))
resultraw = rbind(resultraw,c(n,pp,res1))
write.csv(resultraw0,paste0("./result/T_0_oracle_size_n",n,"_pp",pp,"_v1.csv"),row.names = F)
write.csv(resultraw,paste0("./result/T_oracle_size_n",n,"_pp",pp,"_v1.csv"),row.names = F)











#########################################
######################################
#########plot
############################################################
reptime = 2000

n=1000

ppset= seq(0,0.118,0.006)

data =c()
data3 =c()
for (pp in ppset) {

  temp = read.csv(file=paste0("./result/ORACLE_dist/T_0_oracle_size_n",n,"_pp",pp,"_v1.csv"),header = F)
  temp=as.numeric(temp[2:length(temp[,1]),])
  data=rbind(data,temp)
  
      temp = read.csv(file=paste0("./result/ORACLE_dist/T_oracle_size_n",n,"_pp",pp,"_v1.csv"),header = F)
      temp=as.numeric(temp[2:length(temp[,1]),])
      data3=rbind(data3,temp)
}

Esizesym = c()
Esizesym3 = c()
for (i in 1:length(data3[,1])) {
  r95 = sum(as.numeric(data[i,4:length(data[i,])])<0.05)/reptime
  Esizesym=rbind(Esizesym,c(as.numeric(data[i,2]),r95))
  
  r95 = sum(as.numeric(data3[i,4:length(data3[i,])])<0.05)/reptime
  Esizesym3=rbind(Esizesym3,c(as.numeric(data3[i,2]),r95))

}


par(mar = c(4.1, 4, 0.1, 0.1))
plot(Esizesym[,1],Esizesym3[,2],type = "b",pch=0,col=1,lty=1,xlab = expression(p),ylab = "Empirical Power",ylim = c(0,1))
lines(Esizesym[,1],Esizesym[,2],type="b",pch=3,col=1,lty=3)

legend( legend = c(expression(paste(T^"*")),
                   expression(paste(T[0]^"*"))),
        pch=c(0,3),col=c(1,1),lty=c(1,3),bty = "n",x=0,y=0.7,cex=1,pt.cex = 1,y.intersp = 1,seg.len=3)







