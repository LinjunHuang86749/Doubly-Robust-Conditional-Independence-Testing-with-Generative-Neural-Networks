



#######################################
######################################
#########size calculation, comment out before run on cluster
############################################################
reptime = 1000

n_set=c(200,600,1000,1600,2000)

data1 =c()
data2 =c()
data3 = c()
data4 = c()

for (n in n_set) {
  temp = read.csv(file=paste0("./result/comparewithkci/p_val_mx_n_",n,"_fd_1_ppvalue_0.0.csv"),header = F)$V1
  data1=rbind(data1,temp)
  
  temp = read.csv(file=paste0("./result/comparewithkci/p_val_mx_n_",n,"_fd_2_ppvalue_0.0.csv"),header = F)$V1
  data2=rbind(data2,temp)
  
  temp = read.csv(file=paste0("./result/comparewithkci/p_val_mx_n_",n,"_fd_3_ppvalue_0.0.csv"),header = F)$V1
  data3=rbind(data3,temp)
  
  temp = read.csv(file=paste0("./result/comparewithkci/p_val_mx_n_",n,"_fd_4_ppvalue_0.0.csv"),header = F)$V1
  data4=rbind(data4,temp)
  
}


Esizesym1 = c()
Esizesym2= c()
Esizesym3= c()
Esizesym4= c()

for (i in c(1,2,3,4,5)) {
Esizesym1 = rbind(Esizesym1,c(n_set[i],mean(data1[i,]<0.05),quantile(data1[i,],0.05)))
Esizesym2 = rbind(Esizesym2,c(n_set[i],mean(data2[i,]<0.05),quantile(data2[i,],0.05)))
Esizesym3 = rbind(Esizesym3,c(n_set[i],mean(data3[i,]<0.05),quantile(data3[i,],0.05)))
Esizesym4 = rbind(Esizesym4,c(n_set[i],mean(data4[i,]<0.05),quantile(data4[i,],0.05)))
}

Esizesym5= rbind(c(200,0.064),
                 c(600,0.068),
                 c(1000,0.072),
                 c(1600,0.056),
                 c(2000,0.057))






par(mar = c(4.1, 4.3, 0.1, 0.5))
plot(Esizesym5[,1],Esizesym5[,2],type = "b",pch=1,col=1,lty=1,xlab = "n",ylab = "Empirical Size",ylim = c(0.02,0.7),cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5,lwd = 1.9,cex=1.1)
lines(Esizesym2[,1],Esizesym2[,2],type="b",pch=2,col=1,lwd = 1.9,cex=1.1,lty=2)
lines(Esizesym3[,1],Esizesym3[,2],type="b",pch=3,col=1,lwd = 1.9,cex=1.1,lty=3)
lines(Esizesym4[,1],Esizesym4[,2],type="b",pch=4,col=1,lwd = 1.9,cex=1.1,lty=4)
lines(Esizesym1[,1],Esizesym1[,2],type="b",pch=5,col=1,lwd = 1.9,cex=1.1,lty=5)



abline(h=0.05,lty=3,col="red")


# legend(ncol = 3 , legend = c(expression(SplitKCI[1]),
#                    expression(SplitKCI[1.1]),
#                    expression(SplitKCI[1.4]),
#                    expression(SplitKCI[1.7]),
#                    expression(hat(T)[2])),
#         pch=c(1,2,3,4,5),col=c(1,1,1,1,1),lty=c(1,2,3,4,5),bty = "n",x=275,y=0.77,cex=1.1,pt.cex = 1.2,y.intersp = 0.3,x.intersp = 0.3,lwd=2,seg.len=3)







########################################################
#####################################################
#########power n=600
#######################################################
n=600
rejc = c(0,0.004,0.026,0.0439)
p_set = c(0.05,0.10,0.15,0.20,0.25)

data1 =c()
data2 =c()
data3 = c()
data4 = c()

for (pp in c(0.05,0.10,0.15,0.20,0.25)) {
  temp = read.csv(file=paste0("./result/comparewithkci/power_p_val_mx_n_",n,"_fd_1_ppvalue_",pp,".csv"),header = F)$V1
  data1=rbind(data1,temp)
  
  temp = read.csv(file=paste0("./result/comparewithkci/power_p_val_mx_n_",n,"_fd_2_ppvalue_",pp,".csv"),header = F)$V1
  data2=rbind(data2,temp)
  
  temp = read.csv(file=paste0("./result/comparewithkci/power_p_val_mx_n_",n,"_fd_3_ppvalue_",pp,".csv"),header = F)$V1
  data3=rbind(data3,temp)
  
  temp = read.csv(file=paste0("./result/comparewithkci/power_p_val_mx_n_",n,"_fd_4_ppvalue_",pp,".csv"),header = F)$V1
  data4=rbind(data4,temp)
  
}

Esizesym1p = c(0,0.05)
Esizesym2p= c(0,0.05)
Esizesym3p= c(0,0.05)
Esizesym4p=c(0,0.05)







for (i in c(1,2,3,4,5)) {
  Esizesym1p = rbind(Esizesym1p,c(p_set[i],mean(data1[i,]<=rejc[1])))
  Esizesym2p = rbind(Esizesym2p,c(p_set[i],mean(data2[i,]<rejc[2])))
  Esizesym3p = rbind(Esizesym3p,c(p_set[i],mean(data3[i,]<rejc[3])))
  Esizesym4p = rbind(Esizesym4p,c(p_set[i],mean(data4[i,]<rejc[4])))
}



Esizesym5p = rbind(c(0,0.05),
                   c(0.05,0.149),
                   c(0.10,0.415),
                   c(0.15,0.755),
                   c(0.20,0.955),
                   c(0.25,0.998))





par(mar = c(4.1, 4.3, 0.1, 0.5))
plot(Esizesym5p[,1],Esizesym5p[,2],type = "b",pch=1,col=1,lty=1,xlab = "p",ylab = "Size Adjusted Power",ylim = c(0.02,1),cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5,lwd = 1.9,cex=1.1)
lines(Esizesym2p[,1],Esizesym2p[,2],type="b",pch=2,col=1,lwd = 1.9,cex=1.1,lty=2)
lines(Esizesym3p[,1],Esizesym3p[,2],type="b",pch=3,col=1,lwd = 1.9,cex=1.1,lty=3)
lines(Esizesym4p[,1],Esizesym4p[,2],type="b",pch=4,col=1,lwd = 1.9,cex=1.1,lty=4)
#lines(Esizesym1p[,1],Esizesym1p[,2],type="b",pch=5,col=1,lwd = 1.9,cex=1.1,lty=5)



legend(legend = c(expression(hat(T)[2]),
                  expression(SplitKCI[1.1]),
                  expression(SplitKCI[1.4]),
                  expression(SplitKCI[1.7]),
                  expression(SplitKCI[1])),
       pch=c(1,2,3,4,5),col=c(1,1,1,1,1),lty=c(1,2,3,4,5),bty = "n",x=0,y=1.06,cex=1.1,pt.cex = 1.2,y.intersp = 0.3,x.intersp = 0.5,lwd=1.9,seg.len=4)




















































































