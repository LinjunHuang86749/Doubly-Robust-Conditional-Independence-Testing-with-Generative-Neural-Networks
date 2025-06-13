
library(mvtnorm)
# # 
# # 
# n=1600
n=1000

pp=0
# 

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
   
   
   
   # boottemp0 = rep(0,Boottime)
   # boottemp = rep(0,Boottime)
   # eboot=matrix(rnorm(n*Boottime),nrow = Boottime)
   # 
   # for (bb in 1:Boottime) {
   #   bootmatrix0 = FF_matrix0*(eboot[bb,]%*%t(eboot[bb,]))
   #   bootmatrix = FF_matrix*(eboot[bb,]%*%t(eboot[bb,]))
   #   boottemp0[bb]  = sum( bootmatrix0)/((n-1))
   #   boottemp[bb]  = sum( bootmatrix)/((n-1))
   # }
   
   res10[rr] = stat0
   res1[rr] = stat
  
}

# qq11 = as.matrix(dist(X,method = "manhattan"))


# 
# mean(res1[1:680]<0.05)



resultraw0 = rbind(resultraw0,c(n,pp,res10))
resultraw = rbind(resultraw,c(n,pp,res1))
write.csv(resultraw0,paste0("./result/T_0_oracle_empirical_size_n",n,"_pp",pp,"_v1.csv"),row.names = F)
write.csv(resultraw,paste0("./result/T_oracle_empirical_size_n",n,"_pp",pp,"_v1.csv"),row.names = F)














####################################################
####################################################
####################################################


res1 = read.csv(file=paste0("./result/T_oracle_empirical_size_n",1000,"_pp",0,"_v1.csv"),header = F)
res1=as.numeric(res1[2:length(res1[,1]),3:2002])
res10 = read.csv(file=paste0("./result/T_0_oracle_empirical_size_n",1000,"_pp",0,"_v1.csv"),header = F)
res10=as.numeric(res10[2:length(res10[,1]),3:2002])





###
par(mar = c(4.1, 4, 0.1, 0.1))
hist(res1,xlim=c(-0.3,0.4),ylim=c(0,140),col='blue',border=F,breaks = 45,main = NULL,xlab = "x")
hist(res10,add=T,col=scales::alpha('red',.5),border=F,breaks = 45)
box()
legend( legend = c(expression(paste(T^"*")),
                   expression(paste(T[0]^"*"))),
        col=c("blue",scales::alpha('red',.5)),bty = "n",x=0.24,y=100,cex=1.2,pt.cex = 1,y.intersp = 0.7,lwd=10)













