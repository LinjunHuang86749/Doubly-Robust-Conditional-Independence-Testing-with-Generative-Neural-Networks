#####same as v1, only makes the variance and slope different
command.args = commandArgs(trailingOnly = TRUE) 
n = as.numeric(command.args[1])
##100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400 intotal 4
# d1 = as.numeric(command.args[2])##0.1,1,2,3,4 in total 5
# d2 = as.numeric(command.args[3])##3,4,5 in total 3


library(mvtnorm)
# # 
# # 
#n=500
d1=4.8
d2=1





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
  beta2 = solve(t(X0)%*%X0)%*%t(X0)%*%Z0
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
#mean(res1[1:340]<0.05)



resultraw = rbind(resultraw,c(n,d1,d2,res1))

write.csv(resultraw,paste0("./result/no_robust_case_size_n",n,"_delta",d1,"_delta2",d2,"_v6.csv"),row.names = F)
















##
#######################################
######################################
#########size calculation, comment out before run on cluster
############################################################
reptime = 2000


data =c() ##linear reg
data3 =c()####converge faster
data4 = c()###true beta
data5 = c()###converge slower
data6 = c()###converge slower
for (n in c(100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400)) {
  
  temp = read.csv(file=paste0("./result/infeasable/no_robust_case_size_n",n,"_delta",1,"_delta2",1,"_v1.csv"),header = F)
  temp=as.numeric(temp[2:length(temp[,1]),])
  data=rbind(data,temp)
  
  temp = read.csv(file=paste0("./result/infeasable/no_robust_case_size_n",n,"_delta",4.8,"_delta2",4.8,"_v3.csv"),header = F)
  temp=as.numeric(temp[2:length(temp[,1]),])
  data3=rbind(data3,temp)
  
  temp = read.csv(file=paste0("./result/infeasable/no_robust_case_size_n",n,"_delta",1,"_delta2",1,"_v4.csv"),header = F)
  temp=as.numeric(temp[2:length(temp[,1]),])
  data4=rbind(data4,temp)
  
  temp = read.csv(file=paste0("./result/infeasable/no_robust_case_size_n",n,"_delta",3.2,"_delta2",3.2,"_v5.csv"),header = F)
  temp=as.numeric(temp[2:length(temp[,1]),])
  data5=rbind(data5,temp)
  
  temp = read.csv(file=paste0("./result/infeasable/no_robust_case_size_n",n,"_delta",4.8,"_delta2",1,"_v6.csv"),header = F)
  temp=as.numeric(temp[2:length(temp[,1]),])
  data6=rbind(data6,temp)
  
}

Esizesym = c()
Esizesym3 = c()
Esizesym4 = c()
Esizesym5 = c()
Esizesym6 = c()
for (i in 1:length(data[,1])) {
  r95 = sum(as.numeric(data[i,4:length(data[i,])])<0.05)/reptime
  Esizesym=rbind(Esizesym,c(as.numeric(data[i,1]),as.numeric(data[i,2]),as.numeric(data[i,3]),r95))
  
  r95 = sum(as.numeric(data3[i,4:length(data3[i,])])<0.05)/reptime
  Esizesym3=rbind(Esizesym3,c(as.numeric(data3[i,1]),as.numeric(data3[i,2]),as.numeric(data3[i,3]),r95))
  
  r95 = sum(as.numeric(data4[i,4:length(data4[i,])])<0.05)/reptime
  Esizesym4=rbind(Esizesym4,c(as.numeric(data4[i,1]),as.numeric(data4[i,2]),as.numeric(data4[i,3]),r95))
  
  r95 = sum(as.numeric(data5[i,4:length(data5[i,])])<0.05)/reptime
  Esizesym5=rbind(Esizesym5,c(as.numeric(data5[i,1]),as.numeric(data5[i,2]),as.numeric(data5[i,3]),r95))
  
  
  r95 = sum(as.numeric(data6[i,4:length(data6[i,])])<0.05)/reptime
  Esizesym6=rbind(Esizesym6,c(as.numeric(data6[i,1]),as.numeric(data6[i,2]),as.numeric(data6[i,3]),r95))
}


par(mar = c(4.1, 4.3, 0.1, 0.1))
plot(Esizesym[,1],Esizesym[,4],type = "b",pch=1,col=1,lty=1,xlab = "n",ylab = "Empirical Size",ylim = c(0.02,0.163),cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5,lwd = 1.9,cex=1.1)
lines(Esizesym3[,1],Esizesym3[,4],type="b",pch=3,col=1,lwd = 1.9,cex=1.1,lty=7)
lines(Esizesym4[,1],Esizesym4[,4],type="b",pch=4,col=1,lwd = 1.9,cex=1.1,lty=4)
lines(Esizesym5[,1],Esizesym5[,4],type="b",pch=5,col=1,lwd = 1.9,cex=1.1,lty=5)
lines(Esizesym6[,1],Esizesym6[,4],type="b",pch=6,col=1,lwd = 1.9,cex=1.1,lty=6)
abline(h=0.05,lty=3,col="red")
legend( legend = c(expression(M[n1]),
                   expression(M[n2]),
                   expression(M[n3]),
                   expression(M[n4]),
                   expression(M[n5])),
        pch=c(1,3,4,5,6),col=c(1,1,1,1,1),lty=c(1,7,4,5,6),bty = "n",x=33,y=0.175,cex=1.2,pt.cex = 1.2,y.intersp = 0.6,lwd=1.9,seg.len=4)







