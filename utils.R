library(dplyr)
library(purrr)
library(outliers)
excel_to_numeric <- function(db, column) {
  return(unname(unlist(db[, column])))
}

substituteValueZero<-function(df){
  df$Input[df$Input == 0] <- mean(df$Input)
  df$Output[df$Output == 0] <- mean(df$Output)
  df$Enquiry[df$Enquiry == 0] <- mean(df$Enquiry)
  df$File[df$File == 0] <- mean(df$File)
  df$Interface[df$Interface == 0] <- mean(df$Interface)
  df$Effort[df$Effort == 0] <- mean(df$Effort)
  return (df)
}
outliers <- function(dataset){
  dataset %>%
    select_if(is.numeric) %>% 
    map(~ boxplot.stats(.x)$out) 
}
removeOut<- function(dataset){
    s<-outliers(dataset)
    dataset<- dataset[!dataset$Input %in% s$Input,]
    dataset<- dataset[!dataset$Output %in% s$Output,]
    dataset<- dataset[!dataset$Enquiry %in% s$Enquiry,]
    dataset<- dataset[!dataset$Interface %in% s$Interface,]
    dataset<- dataset[!dataset$Effort%in% s$Effort,]
   return(dataset)
}

