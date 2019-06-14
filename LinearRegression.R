library(caret)
stepWiseTest<-function(dataset){
  # R quadro pari a 0.5 (accettabile ma non esageratamente) -----------------------------
  new_linear_model <-  lm(data = dataset, dataset$Effort ~ dataset$Input + dataset$Output + dataset$Enquiry +dataset$File+ dataset$Interface) 
  # ------------------------- Usare la stepwise per scegliere le variabili da utilizzare per il modello -------
  stepwise <- step(new_linear_model, direction = "both")
  selected_variables <- stepwise$call$formula
  toReturn <- paste("Variabili selezionate ====>",toString(selected_variables))
  return(toReturn)
}

rectRegression <-function(dataset,el){
  ind<-excel_to_numeric(dataset,el)
  dip <-excel_to_numeric(dataset,"Effort")
  plot(ind,dip,xlab=el,ylab = "Effort")
  app<-lm(dip~ind)
  abline(app)
}
testLinearita<- function(dataset){
  par(mfrow=c(2,3))
  namesCol <-colnames(dataset)
  lapply(namesCol[-6], function(el) rectRegression(dataset,el))
  par(mfrow=c(1,1))
  
}
omosc <- function(dataset,el){
  ind<-excel_to_numeric(dataset,el)
  dip <-excel_to_numeric(dataset,"Effort")
  print("variabile indipendende: effort")
  print(el)
  print(bptest(dip ~ ind))
}

omoschedasticita <- function(dataset){
  par(mfrow = c(2,3))
  nameCol <- colnames(dataset)
  lapply(nameCol[-6], function(el) omosc(dataset,el) )
  par(mfrow=c(1,1))
}
statDesc <- function(dataset){
  #------------statistiche descrittive--------------------------------
  print("--------------------------------------------------------------")
  print("-----------------Deviazione Standard--------------------------")
  print(apply(dataset, 2, FUN = sd))
  print("--------------------------------------------------------------")
  print("-----------------Calcolo dei Quantili-------------------------")
  quants = c(0.25, 0.5, 0.75)
  print(sapply(dataset, quantile, probs = quants))
  print("--------------------------------------------------------------")
  print(summary(dataset))
}

ShapTest <- function(dataset, el){
  print(paste("SHAPIRO TEST =>", el))
  ind <- excel_to_numeric(dataset, el)
  print(shapiro.test(ind))
}
printShapiroTest<-function(dataset){
  nameCol <-colnames(dataset)
  lapply(nameCol, function(el) ShapTest(dataset,el))
 if(F){
  print(shapiro.test(dataset$Input))
  print(shapiro.test(dataset$Output))
  print(shapiro.test(dataset$Enquiry))
  print(shapiro.test(dataset$File))
  print(shapiro.test(dataset$Interface))
  print(shapiro.test(dataset$Effort))
 }
}
corr <- function(dataset, el, meth = "pearson"){
  ind<-excel_to_numeric(dataset,el)
  corre <- cor.test(dataset$Effort, dataset$Input, alternative = c("two.sided"), method = c(meth), exact = NULL, conf.level = 0.95)
  print(paste("Correlazione con ",el,"e' r= ", corre[4]))
}

CalcCor<-function (dataset, meth = "pearson"){
  
  corre <- cor.test(dataset$Effort, dataset$Input, alternative = c("two.sided"), method = c(meth), exact = NULL, conf.level = 0.95)
  print(paste("Correlazione con INPUT :", corre[4]))
  corre <- cor.test(dataset$Effort, dataset$Output, alternative = c("two.sided"), method = c(meth), exact = NULL, conf.level = 0.95)
  print(paste("Correlazione con OUTPUT:", corre[4]))
  corre <- cor.test(dataset$Effort, dataset$Enquiry, alternative = c("two.sided"), method = c(meth), exact = NULL, conf.level = 0.95)
  print(paste("Correlazione con ENQUIRY:", corre[4]))
  corre <- cor.test(dataset$Effort, dataset$File, alternative = c("two.sided"), method = c(meth), exact = NULL, conf.level = 0.95)
  print(paste("Correlazione con FILE:", corre[4]))
  corre <- cor.test(dataset$Effort, dataset$Interface, alternative = c("two.sided"), method = c(meth), exact = NULL, conf.level = 0.95)
  print(paste("Correlazione con INTERFACE:", corre[4]))
 # nameCol <-colnames(dataset)
  #lapply(nameCol[-6], function(el) corr(dataset = dataset, el,meth = meth))
}

q <- function(x) { quantile(x, probs=c(0:3)/3, names=FALSE) }


kfold <-function(df){
  train.control <- trainControl(method = "repeatedcv", 
                                number = 10, verboseIter = TRUE, repeats= 5)
  model <- train( Effort~Input+Output+Enquiry+File+Interface, data = datasetNormalizzato, method = "lm",
                  trControl = train.control)
  print(model$resample)
  print(model)
  print("dev standard: ")
  print(sd(model$resample$Rsquared))
}


holdOut <-function(df){
  training.samples <- df$Effort %>%
  createDataPartition(p = 0.66, list = FALSE)
  train.data  <- df[training.samples, ]
  test.data <- df[-training.samples, ]
  # Build the model
  model <- lm( Effort ~ Input + Output + Enquiry +File+ Interface ,data = train.data)
  # Make predictions and compute the R2, RMSE and MAE
  predictions <- model %>% predict(test.data)
  pred=0
  MRE = abs(predictions - test.data$Effort)/test.data$Effort
  for(i in MRE)
    if( i<= 0.25)
      pred=pred+1
  View(MRE)
  print(pred)
  print(data.frame(MdMRE= median(abs(predictions - test.data$Effort)/test.data$Effort),
                   MMRE= mean(abs(predictions - test.data$Effort)/test.data$Effort),Pred=pred/length(predictions)))
}



hol2 <-function(df){
  set.seed(1)
  in_train <- createDataPartition(df$Effort, p = 4/5, list = FALSE)
  training <- df[ in_train,]
  testing  <- df[-in_train,]
  print("num row total: ")
  print(nrow(df))
  print("num row training: ")
  print(nrow(training))
  print("num row testing: ")
  print(nrow(testing))
  lda_fit <- train(Effort ~ Input + Output + Enquiry + File + Interface, data = df, method = "lm")
 print( lda_fit)
  print(lda_fit$resample)
}