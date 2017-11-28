setwd("C:/Users/����/Desktop/new_bigdata_set/above 2000")
hiv1 <- read.csv("hiv.rm.csv")
setwd("C:/Users/����/Desktop/new_bigdata_set/final_hiv_revised")
hiv2 <- read.csv("hiv2.raw.data.csv")
###########################################
hiv.com <- intersect(as.character(hiv1[[2]]), as.character(hiv2[[2]]))
hiv2[!(hiv2[[2]] %in% hiv.com), ]
hiv.1 <- cbind(hiv2[!(hiv2[[2]] %in% hiv.com), ], x2015 = NA, x2016 = NA)
colnames(hiv.1) <- colnames(hiv1)
hiv <- rbind(hiv1, hiv.1)
h.code <- as.character(hiv$Country.Code)
order.code <- order(h.code)
hiv <- hiv[order.code,]

KNN <- function(data, year){
  if(length(which(is.na(data[,year]))) == 0) return(data[,c(1,2, year)])
  na.row <- which(is.na(data[, year])) #���� �⵵���� NA�� row����
  
  for(i in 1:length(na.row)){
    col <- !is.na(data[na.row[i],]) #key observation���� NA�� �ƴ� col ����
    collected.col <- data[, col] #data���� col column���� ����
    key <- collected.col[na.row[i],] #key observation�� row ����
    index <- complete.cases(collected.col) #NA�� �ϳ��� ���� row ����
    non.na <- collected.col[index,] #NA�� ������.
    a <- apply(as.data.frame(non.na[,-c(1,2)]), 1, "-", key[,-c(1,2)]) #�� ���� ��
    b <- unlist(a) ^ 2 #���� ����
    c <- as.data.frame(matrix(b, length(b)/(length(collected.col)-2), 
                              length(collected.col)-2, byrow = T)) #vector b�� data.frame���� ����ȯ
    colnames(c) <- colnames(non.na)[-c(1, 2)]
    p.length <- apply(c, 1, sum) #�� �⵵���� ������ ���̵��� ��
    o.p <- order(p.length) #���̵��� ���� �ּ� ������ �迭
    n.point <- o.p[which(!is.na(data[o.p, year]))][1:5] #year Į���� NA�� �ƴ� �͵� �߿��� ������ 5��
    d <- data[n.point, year] #key�� ����� 5���� point�� ���� ����
    data[na.row[i], year] <- mean(d, na.rm = T) # ����� ��ó ������ ����� �־���.
  }
  return(data[,c(1, 2, year)])
}

hiv.0 <- KNN(hiv, 19)
setwd("C:/Users/����/Desktop/new_bigdata_set/final data revised")
write.csv(hiv.0, "hiv.rv.csv", row.names = F)