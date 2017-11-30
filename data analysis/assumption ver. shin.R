setwd("c:/Users/����/Desktop/new_bigdata_set/Final Total Data")
DF <- read.csv("Sleeping princess in penguin room.csv")
life <- DF[[3]]
gdp <- DF[[4]]; sani <- DF[[5]]; pre <- DF[[6]]; pri <- DF[[7]]
sec <- DF[[8]]; ter <- DF[[9]]; smo <- DF[[11]]; ob <- DF[[12]]
al <- DF[[13]]; co2 <- DF[[14]]; hiv <- DF[[15]]

n <- nrow(DF); p <- ncol(DF) - 4

reg <- lm(life~gdp+sani+pre+pri+sec+ter+smo+ob+al+co2+hiv)


#residual plot / ������ homoscadesity�� �� ������ �ʴ´�. - WLS�� ����� �� ����.
par(mfrow = c(1,2))
plot(reg$residuals, type = "n", main = "residual plot", ylab = "residuals"); abline(h=0, lty="dotted")
text(reg$residuals, names(reg$residuals), cex = 0.7)
plot(reg$fitted.values, reg$residuals, type = "n", main = "residual plot", xlab = "y.hat", ylab = "residuals")
abline(h = 0, lty = "dotted")
text(reg$fitted.values, reg$residuals, names(reg$fitted.values), cex = 0.7)
DF$Country.Name[which(reg$fitted.values >= 75)]


#ANOVA
anova.reg <- anova(reg); anova.reg

########## Assumption Test #########
#independence
library(lmtest)
dwtest(life ~ gdp+sani+pre+pri+sec+ter+smo+ob+al+co2+hiv) # H0�� ����.
  #��� independence��. p.value �̳� ŭ
#normality test
# residual
r <- reg$residuals
# MSE
mse <- t(r) %*% r / (n - p - 1) 
# standardized residual
e <- r/c(sqrt(mse))
par(mfrow = c(1,1))
qqnorm(e)
abline(0, 1, col=2)
   #��� �� �븻 ���̽�Ű
#####################################
######outlier, influence points#########
# studentized residual
alpha <- 0.05
temp <- (n - p - 2)/ (n - p - 1 - r^2)
t <- r * sqrt(abs(temp)) * sign(temp)
out.id <- which(abs(t) > qt(1-alpha/2, n - p - 2)); out.id
#plot
y.hat <- reg$fitted.values
plot(e, type = "n", xlab = "index", ylab = "residual", main="studentized residual")
text(e, cex = 0.7)
text(out.id, e[out.id], out.id, col=2, cex = 0.7)
abline(h = 0, col = 2, lty = 2)
points(out.id, e[out.id], col = 4, cex = 2)
  #outlier�� ourlier�� �ƴ� �������� �ʹ� ����.

#1.5 IQR
summary(y.hat)
IQR <- quantile(r, prob = 0.75) - quantile(r, prob = 0.25)
lower.bound <- quantile(r, prob = 0.25) - 1.5*IQR
upper.bound <- quantile(r, prob = 0.75) + 1.5*IQR
#out.shit <- which(r >= quantile(r, prob = 0.975) | r <= quantile(r, prob = 0.025))
out.IQR <- which(r <= lower.bound | r >= upper.bound)
#plot IQR
y.hat <- reg$fitted.values
plot(r, type = "n", xlab = "index", ylab = "residual", main = "1.5 IQR outlier")
text(r, cex = 0.7)
text(out.IQR, r[out.IQR], out.IQR, col=2, cex = 0.7)
abline(h = 0, col = 2, lty = 2)
points(out.IQR, r[out.IQR], col = 4, cex = 3)
   ## 22, 58, 106
#box plot
boxplot(r, main = "residual box plot", horizontal = T)

#####influential point#####
#Cook's distance
X1 <- as.matrix(DF[,-c(1, 2, 3, 10)])
X1[,1] <- X1[,1]/(10^9)  #gdp �ʹ� Ŀ�� R�� ���ߵ���. �ٵ� double�� ����ȯ�ϱ�� �Ⱦ��.
X <- cbind(rep(1, n), X1)
H <- X %*% solve(t(X) %*% X) %*% t(X)
h <- diag(H)
C <- ((r^2)/(p+1)) * (h/(1-h))
infl.id <- names(C)[C > 1]
plot(C, type = "n", main = "Cook's distance, influential point")
text(C, cex = 0.7)
abline(h = 1, col = 2, lty = 2)
points(infl.id, C[infl.id], col = 4, cex = 2.2)
   ## 44, 106, 145
#DFFITS
DFFITS <- t * sqrt(h / (1 - h))
plot(DFFITS, ylim = c(-0.5, 3.5), type = "n", main = "DFFITS, influential points")
text(abs(DFFITS), cex = 0.7)
abline(h = 2 * sqrt((p + 1)/(n - p - 1)), col = 2, lty = 2)
   #��ź~ �츮�� ���� ���ƿ�~ / studentized t�� ��ź���� DFFITS�� ��ź ��
#############################################
################assumption test##################


##############influential point delete fitted model ################
infl.id # 44, 106, 145
DF.1 <- DF[-as.numeric(infl.id),]
life.1 <- DF.1[[3]]
gdp.1 <- DF.1[[4]]; sani.1 <- DF.1[[5]]; pre.1 <- DF.1[[6]]; pri.1 <- DF.1[[7]]
sec.1 <- DF.1[[8]]; ter.1 <- DF.1[[9]]; smo.1 <- DF.1[[11]]; ob.1 <- DF.1[[12]]
al.1 <- DF.1[[13]]; co2.1 <- DF.1[[14]]; hiv.1 <- DF.1[[15]]

n.1 <- nrow(DF.1); p <- ncol(DF.1) - 4

reg.1 <- lm(life.1~gdp.1+sani.1+pre.1+pri.1+sec.1+ter.1+smo.1+ob.1+al.1+co2.1+hiv.1)
obj <- summary(reg.1)
names(obj)
round(obj$coefficients, 4)
###########################�α׺�ȯ########################
log.gdp <- log(gdp.1, 10); log.co2 <- log(co2.1, 2); log.hiv <- log(hiv.1, 2)
reg.log <- lm(life.1~log.gdp+sani.1+pre.1+pri.1+sec.1+ter.1+smo.1+ob.1+al.1+log.co2+log.hiv)
obj.log <- summary(reg.log)

round(obj.log$coefficients, 4)