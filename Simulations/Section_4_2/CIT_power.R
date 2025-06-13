#####function used in the noise outsourcing lemma are estimated using whole data. 
command.args = commandArgs(trailingOnly = TRUE)
dz = as.numeric(command.args[1])##50,100,150,200,250
b = as.numeric(command.args[2])## under alternative: b = 0.15, 0.30, 0.45, 0.60,0.75
dt = as.numeric(command.args[3])##  1,2,3,...25 if bn=2:

# dz <- 200
# b <- 0.15
# dt = 25

library(mvtnorm)
# # 
# # 
# 
n = 2000
# d1=1.5
# d2=1.5

# Code From Cai
#==============================================================================
mutualDependenceFree = function(u,v,w)
{
  if(is.null(dim(u))) {n = length(u)} else { n = dim(u)[1] }
  if(is.null(dim(u))) {p = 1} else { p = dim(u)[2] }
  if(is.null(dim(v))) {q = 1} else { q = dim(u)[2] }
  if(is.null(dim(w))) {r = 1} else { r = dim(u)[2] }
  uij = as.matrix(dist(u, diag = T, upper = T))
  ui = exp(-u)+exp(u-1)
  vij = as.matrix(dist(v, diag = T, upper = T))
  vi = exp(-v)+exp(v-1)
  uu = exp(-uij)+ui%*%matrix(1, 1, n)+matrix(1, n, 1)%*%t(ui)+2*exp(-1)-4
  vv = exp(-vij)+vi%*%matrix(1, 1, n)+matrix(1, n, 1)%*%t(vi)+2*exp(-1)-4
  ww = as.matrix(exp(-dist(w, diag = T, upper = T)))
  conCor = mean(uu*vv*ww)
  conCor
}

mutualDependenceFree_multiZ = function(u,v,w)
{
  if(is.null(dim(u))) {n = length(u)} else { n = dim(u)[1] }
  if(is.null(dim(u))) {p = 1} else {stop("X should be univariate!") }
  if(is.null(dim(v))) {q = 1} else {stop("Y should be univariate!") }
  if(is.null(dim(w))) {stop("Z should be multivariate!")} else { r = dim(w)[2] }
  uij = as.matrix(dist(u, diag = T, upper = T))
  ui = exp(-u)+exp(u-1)
  vij = as.matrix(dist(v, diag = T, upper = T))
  vi = exp(-v)+exp(v-1)
  uu = exp(-uij)+ui%*%matrix(1, 1, n)+matrix(1, n, 1)%*%t(ui)+2*exp(-1)-4
  vv = exp(-vij)+vi%*%matrix(1, 1, n)+matrix(1, n, 1)%*%t(vi)+2*exp(-1)-4
  ww = as.matrix(exp(-wdist(w)))
  conCor = mean(uu*vv*ww)
  conCor
}

wdist = function(w)
{
  if(is.null(dim(w))) {stop("Z should be multivariate!")} else { r = dim(w)[2] }
  s1 = dist(w[,1], diag = T, upper = T)
  for(i in 2:r)
  {
    s1 = s1+dist(w[,i], diag = T, upper = T)
  }
  s1
}

IndependenceFree = function(u,v)
{
  if(is.null(dim(u))) {n = length(u)} else { n = dim(u)[1] }
  if(is.null(dim(u))) {p = 1} else { p = dim(u)[2] }
  if(is.null(dim(v))) {q = 1} else { q = dim(u)[2] }
  #if(is.null(dim(w))) {r = 1} else { r = dim(u)[2] }
  uij = as.matrix(dist(u, diag = T, upper = T))
  ui = exp(-u)+exp(u-1)
  vij = as.matrix(dist(v, diag = T, upper = T))
  vi = exp(-v)+exp(v-1)
  uu = exp(-uij)+ui%*%matrix(1, 1, n)+matrix(1, n, 1)%*%t(ui)+2*exp(-1)-4
  vv = exp(-vij)+vi%*%matrix(1, 1, n)+matrix(1, n, 1)%*%t(vi)+2*exp(-1)-4
  #ww = as.matrix(exp(-dist(w, diag = T, upper = T)))
  conCor = mean(uu*vv)
  conCor
}

### Define kernel functions
k_gaussian = function(t, h)
{
  u = t/h
  return(exp(-t(u)%*%u/2)/sqrt(2*pi))
}
k_ep = function(t, h)
{
  u = t/h
  return(0.75*(1-u^2)*(u<=1)*(u>=-1))
}


UEstimate = function(x1, z1, X, Z, h)
{
  #if(is.null(nrow(X))) {n = length(X)} else {n = dim(X)[1,]}
  ZK = GetZK(z1, Z, h)
  uNum = mean(ZK*(X<=x1))
  return(uNum/mean(ZK))
}

VEstimate = function(y1, z1, Y, Z, h)
{
  ZK = GetZK(z1, Z, h)
  vNum = mean(ZK*(Y<=y1))
  return(vNum/mean(ZK))
}

WEstimate = function(z1, Z)
{
  return(mean(Z<=z1))
}


GetZK = function(z1, Z, h)
{
  if(is.null(nrow(Z)))
  {
    n = length(Z)
    Kh = rep(0,n)
    for (i in 1:n) {
      Kh[i] = k_gaussian(z1-Z[i], h)
    }
    return(Kh)
  }
  if(!is.null(nrow(Z)))  {
    n = dim(Z)[1]
    Kh = rep(0,n)
    for (i in 1:n) {
      Kh[i] = k_gaussian(z1-Z[i,], h)
    }
    return(Kh)
  }
}


CI.test = function(X, Y, Z, h)
{
  if(is.null(nrow(X))) {n = length(X)} else {n = dim(X)[1,]}
  if(is.null(dim(X))) {p = 1} else {stop("X should be univariate!") }
  if(is.null(dim(Y))) {q = 1} else {stop("Y should be univariate!") }
  if(is.null(dim(Z))) {r = 1} else { r = dim(Z)[2] }
  
  if(r==1)
  {
    ### Estimate U, V, W
    U = rep(0, n)
    V = U; W = U
    for (i in 1:n) {
      U[i] = UEstimate(X[i], Z[i], X, Z, h)
      V[i] = VEstimate(Y[i], Z[i], Y, Z, h)
      W[i] = WEstimate(Z[i], Z)
    }
    conCor = mutualDependenceFree(U,V,W)
    return(conCor)
  }
  if(r>1)
  {
    #### Estimate U, V, W
    U = rep(0, n)
    V = U; W = matrix(0, n, r)
    for (i in 1:n) {
      U[i] = UEstimate(X[i], Z[i], X, Z, h)
      V[i] = VEstimate(Y[i], Z[i], Y, Z, h)
      for(j in 1:r)
      {
        if(j == 1){ W[i,j] = WEstimate(Z[i,j], Z[,j]) } else { W[i,j] = UEstimate(Z[i,j], Z[i,1:(j-1)], Z[,j], Z[,1:(j-1)],h)}
      }
    }
    conCor = mutualDependenceFree_multiZ(U,V,W)
    return(conCor)
  }
}


Independence.test = function(X, Y)
{
  if(is.null(nrow(X))) {n = length(X)} else {n = dim(X)[1,]}
  if(is.null(dim(X))) {p = 1} else { p = dim(X)[2] }
  if(is.null(dim(Y))) {q = 1} else { q = dim(Y)[2] }
  #if(is.null(dim(Z))) {r = 1} else { r = dim(Z)[2] }
  
  #### Estimate U, V,
  U = rep(0, n); V = U;
  for (i in 1:n) {
    U[i] = WEstimate(X[i], X)
    V[i] = WEstimate(Y[i], Y)
  }
  conCor = IndependenceFree(U,V)
  conCor
}

##################################################################################

if (bn==1){
  ddt = 40
  # reptime = 1000

}

if (bn==2){
  ddt = 20
  # reptime = 500
}


res1 = c()


# n^(-6/8)
resultraw = c()



for (rr in ((dt-1)*ddt+1):(dt*ddt)) {
  set.seed(rr)
  # cat(paste("rr is ", rr,". \n"))

  temp_result = -10000
  
  # cat(paste("runing bn is 2. \n"))
  beta_X <- runif(dz)
  beta_X <- matrix(beta_X, nrow = 1)/sum(abs(beta_X))
  beta_Y <- runif(dz)
  beta_Y <- matrix(beta_Y, nrow = 1)/sum(abs(beta_Y))  
  
  Z <- rnorm(dz*n) |> matrix(ncol = dz) 
  error_X <- rnorm(n, mean = 0, sd = 0.5)
  error_Y <- rnorm(n, mean = 0, sd = 0.5)
  X <- sin(beta_X%*% t(Z) + error_X) |> as.vector()
  Y <- cos(beta_Y%*% t(Z) + b*X + error_Y) |> as.vector()
  h = 15
  temp_result = CI.test(X, Y, Z, h) * n

 
 res1 = c(res1, temp_result)
  
}


resultraw = rbind(resultraw,c(dz,bn,dt,res1))

write.csv(resultraw,paste0("./result/cit_power_dz",dz,"_b",b,"_dt",dt,"_v1.csv"),row.names = F)








# ###################################################################
# #######################################   size     ################
# # ############################################################
n=2000
bn=2
dz=200
####rej criterion from bn=1
rejcc = c(3.827277e-08, 2.590684e-14 ,1.469721e-20,7.257442e-27,2.910057e-33)

rejcc10 = c(2.925009e-08, 1.933130e-14 ,1.109569e-20,5.086660e-27,1.922798e-33)

ddt = 20#
reptime = 500


bb_set =c(0.15,0.30,0.45,0.60,0.75)
dt_set = seq(1,25,1)
data1=c()



for (bb in c(0.15,0.30,0.45,0.60,0.75)) {
  data1temp = c(bb,dz)
  for (dt in dt_set) {
    temp=read.csv(file=paste0("./result/cai/cit_power_dz",dz,"_bn",bn,"_bb",bb,"_dt",dt,"_v1.csv"),header = T)
    temp=as.numeric(temp[4:length(temp)])
    data1temp =c(data1temp,temp)
  }
  data1 =rbind(data1,c(quantile(data1temp,0.95),data1temp))
}


Esizen1 = c()
for (i in c(1,2,3,4,5)) {
  #r90 = sum(as.numeric(data[i,5:length(data)])>q90)/reptime
  r95 = sum(data1[i,4:length(data1[1,])]>rejcc[4])/reptime
  r90 = sum(data1[i,4:length(data1[1,])]>rejcc10[4])/reptime
  #prop1 = sum(as.numeric(Jstar[i,5:length(Jstar)])==as.numeric(Jstar[i,2]))/reptime ##last dimention
  #prop1 = sum(as.numeric(Jstar[i,5:length(Jstar)])==1)/reptime ###fixed dimention
  Esizen1=rbind(Esizen1,c(data1[i,1],data1[i,2],data1[i,3],r95,r90))
}















