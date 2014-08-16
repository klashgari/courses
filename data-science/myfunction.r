# a simple example R file
myfunction <- function(x){
  y <- rnorm(100)
  mean(y)
}

# mean(data[data$Ozone > 31 & data$Temp > 90,]$Solar.R, na.rm=T)

# df<-data[data$Ozone > 31 & data$Temp > 90,]
# mean(df$Solar.R, na.rm=T)
# 