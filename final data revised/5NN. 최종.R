setwd("C:/Users/양수형/Documents/GitHub/new_bigdata_set/above 2000")
KNN <- function(data, year){ #data : raw data, year : 기준년도 # column
  if(length(which(is.na(data[,year]))) == 0) return(data[,c(1,2, year)])
  na.row <- which(is.na(data[, year])) #기준 년도에서 NA인 row추출
  
  for(i in 1:length(na.row)){
    col <- !is.na(data[na.row[i],]) #key observation에서 NA가 아닌 col 추출
    collected.col <- data[, col] #data에서 col column들을 추출
    key <- collected.col[na.row[i],] #key observation의 row 추출
    index <- complete.cases(collected.col) #NA가 하나도 없는 row 추출
    non.na <- collected.col[index,] #NA를 제거함.
    d <- apply(as.data.frame(non.na[,-c(1,2)]), 1, "-", key[,-c(1,2)]) #두 값의 차
    d2 <- unlist(d) ^ 2 #차의 제곱
    d2.matrix <- as.data.frame(matrix(d2, length(d2)/(length(collected.col)-2), 
                              length(collected.col)-2, byrow = T)) #vector b를 data.frame으로 형변환
    colnames(d2.matrix) <- colnames(non.na)[-c(1, 2)]
    p.length <- apply(c, 1, sum) #각 년도별로 구해진 길이들의 합
    o.p <- order(p.length) #길이들의 합을 최소 순서로 배열
    n.point <- o.p[which(!is.na(data[o.p, year]))][1:5] #year 칼럼에 NA가 아닌 것들 중에서 작은거 5개
    n.data <- data[n.point, year] #key와 가까운 5개의 point의 점수 추출
    data[na.row[i], year] <- mean(n.data, na.rm = T) # 추출된 근처 값들의 평균
  }
  return(data[,c(1, 2, year)])
}

life <- read.csv("life.rm.csv")
life.0 <- KNN(life, 18)
gdp <- read.csv("gdp.rm.csv")
gdp.0 <- KNN(gdp, 19)
co2 <- read.csv("co2.rm.csv")
co2.0 <- KNN(co2, 17)
ter <- read.csv("ter.rm.csv")
ter.0 <- KNN(ter, 18)

#smoking은 이전 년도 데이터가 없어서 전체 평균으로 결측치를 대체함.
smo <- read.csv("smo.rm.2.CSV")
which(is.na(smo[,3]))
which(is.na(smo[,4]))
avg <- apply(smo[,c(3,4)], 2, mean, na.rm = T)
smo[which(is.na(smo[,3])),3] <- avg[1]
smo[which(is.na(smo[,4])),4] <- avg[2]

sec <- read.csv("sec.rm.csv")
sec.0 <- KNN(sec, 18)
obesity <- read.csv("Obesity.rm.csv", header=T)
KNN(obesity, 19)
obs.0 <- obesity[,c(1, 2, 19)]
hiv <- read.csv("hiv2.raw.data.csv")
hiv.0 <- KNN(hiv, 17)
pre <- read.csv("pre.rm.csv")
pre.0 <- KNN(pre, 18)
pri <- read.csv("pri.rm.csv")
pri.0 <- KNN(pri, 18)
sani <- read.csv("sani.rm.csv")
sani.0 <- KNN(sani, 18)


write.csv(co2.0, "co2.rv.csv", row.names = F)
write.csv(gdp.0, "gdp.rv.csv", row.names = F)
write.csv(hiv.0, "hiv.rv.csv", row.names = F)
write.csv(life.0, "life.rv.csv", row.names = F)
write.csv(obs.0, "ob.rv.csv", row.names = F)
write.csv(pre.0, "pre.rv.csv", row.names = F)
write.csv(pri.0, "pri.rv.csv", row.names = F)
write.csv(sani.0, "sani.rv.csv", row.names = F)
write.csv(smo, "smo.rv.csv", row.names = F)
write.csv(sec.0, "sec.rv.csv", row.names = F)
write.csv(ter.0, "ter.rv.csv", row.names = F)

