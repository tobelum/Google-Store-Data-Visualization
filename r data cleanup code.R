library(reticulate)
sample2 <- function(file, n) {
rows <- py_eval(paste("sum(1 for line in open('", file, "'))", sep = '')) - 1
return(import("pandas")$read_csv(file, skiprows = setdiff(1:rows, sample(1:rows, n))))
}
train <- sample2("/Users/Forest/Downloads/all (1)/train.csv", 10000)
train$date <- as.Date(as.character(train$date),"%Y%m%d")
stringr::str_split_fixed
library(stringr)

# device split
device <- data.frame(str_split_fixed(train$device, ",", 16))
colnames(device) <- c("browser",
"browserVersion",
"browserSize",
"operatingSystem",
"operatingSystemVersion",
"isMobile",
"mobileDeviceBranding",
"mobileDeviceModel",
"mobileInputSelector",
"mobileDeviceInfo",
"mobileDeviceMarketingName",
"flashVersion",
"language",
"screenColors",
"screenResolution",
"deviceCategory")
device <- sapply(device, function(x) gsub('.*:',"",x))
device <- data.frame(device)
device <- sapply(device, function(x) gsub("\\W","",x))
train <- cbind(train,device)
train$device <- NULL

# network split
network <- data.frame(str_split_fixed(train$geoNetwork, ",", 11))
train$geoNetwork[1]
colnames(network) <- c("continent",
"subContinent",
"country",
"region",
"metro",
"city",
"cityId",
"networkDomain",
"latitude",
"longitude",
"networkLocation")
network <- sapply(network, function(x) gsub('.*:',"",x))
network <- data.frame(network)
network <- sapply(network, function(x) gsub("\\W","",x))
network <- data.frame(network)

train <- cbind(train,network)

# totals

totals <- data.frame(matrix(nrow=nrow(train),ncol = 6))
colnames(totals) <- c("visits","hits","pageviews","newVisits","bounces","transactionRevenue")
for (i in 1:6){
name = colnames(totals)[i]
number <- grep(name,train$totals)
totals[number,i] <- train$totals[number]
totals[,i] <- ifelse(is.na(totals[,i]),0,totals[number,i])
pat <- paste("^.*",name,".*?([0-9]+).*",sep = "")
totals[number,i] <- gsub(pat, "\\1",totals[number,i])
}
totals <- sapply(totals,function(x) as.numeric(as.character(x)))
train <- cbind(train,totals)
train$totals <- NULL

train$trafficSource <- NULL
train$sessionId <- NULL
library(lubridate)

train$month <- format(as.Date(train$date), "%m")
train$year <- format(as.Date(train$date), "%y")
train$day <- format(as.Date(train$date), "%d")
train$date <- NULL
copy <- train
train$trafficSource <- NULL
row <- sample(nrow(train), 0.7*nrow(train), replace = FALSE)
TrainSet <- train[row,]
ValidSet <- train[-row,]
summary(TrainSet)
summary(ValidSet)


# Create a Random Forest model with default parameters
model1 <- randomForest(transactionRevenue ~ ., data = TrainSet, importance = TRUE)
model1
##########################################################################

# total numbers 
traffic <- data.frame(matrix(nrow=nrow(train),ncol = 13))
colnames(traffic) <- c("gclId",
                      "inTrueDirect",
                      "slot",
                      "isTrueDirect",
                      "source",
                      "medium",
                      "referralPath",
                      "keywords",
                      "adwordsClickInfo",
                      "adNetworkType",
                      "isVideoAd",
                      "targetingCriteria",
                      "campaign")

for (i in 1:ncol(traffic)){
name = colnames(traffic)[i]
number <- grep(name,train$trafficSource)
traffic[number,i] <- train$trafficSource[number] 
traffic[,i] <- ifelse(is.na(traffic[,i]),NA,traffic[number,i])
pat <- paste(".*",name,sep = "")
traffic$extra<- gsub(",.*","",gsub(pat,"",traffic[,i]))
}

totals <- sapply(totals,function(x) as.numeric(as.character(x)))
train <- cbind(train,totals)
train$totals <- NULL


traffic <- data.frame(str_split_fixed(train$trafficSource, ",", 11))
train$geoNetwork[1]
colnames(network) <- c("continent",
                       "subContinent",
                       "country",
                       "region",
                       "metro",
                       "city",
                       "cityId",
                       "networkDomain",
                       "latitude",
                       "longitude",
                       "networkLocation")
network <- sapply(network, function(x) gsub('.*:',"",x))
network <- data.frame(network)
network <- sapply(network, function(x) gsub("\\W","",x))
network <- data.frame(network)
View(network)
train <- cbind(train,network)
train$geoNetwork <- NULL

write.csv(train,"result.csv",row.names = F)

