library(readxl)
library(robustbase)
library(tidyr)
library(lmtest)
library(gvlma)
#library(Rcmdr)
library(MASS)


source('~/Scrivania/Metriche/script/LinearRegression.R')
source('~/Scrivania/Metriche/script/utils.R')
#-----------------Carico  il dataset--------------------------------
dataset_path <- "~/Scrivania/Metriche/esercizio 3/Dataset 2 China2.xlsx"

dataset <- read_excel(path = dataset_path)
dataset <- subset( dataset, select = -1 )
for(i in colnames(dataset)[-7][-1]) {
  vec <- excel_to_numeric(dataset, i)

}

#sostituisco il valore 0 in ogni colonna con la rispettiva media
dataset <-substituteValueZero(dataset)
dataset <- trunc(dataset) # tronco i valori dopo la virgola per ogni elemento
#-----------------Recupero i dati dal dataset-----------------------

print("----------------Statistiche descrittive-----------------------")
statDesc(dataset)
print("------------------Fine statistiche descrittive----------------")
print("----------------------SHAPIRO TEST----------------------------")
printShapiroTest(dataset)
print("-------------------END SHAPIRO TEST---------------------------")

#La statistica W può assumere valori da 0 a 1. Qualora il valore della statistica W sia troppo piccolo, 
#il test rifiuta l'ipotesi nulla che i valori campionari siano distribuiti come una variabile casuale normale. 
datasetNormalizzato <- log(dataset) 
  #print(step(datasetNormalizzato, direction= "backward/forward", criterion = "AIC"))

   #rieseguo lo shapirto test sui dati normalizzati
print("----------Eseguo lo Shapiro test sui dati normalizzati--------")
printShapiroTest(datasetNormalizzato)
print("---------------------------------------------------------------")
#effettuo il boxplot dei dati normalizzati

#r<-removeOut(dataset = datasetNormalizzato)
#boxplot(r)
#eseguo l'analisi descrittiva sui dati normalizzati 
print("----------STATISTICHE DESCRITTIVE SUI DATI NORMALIZZATI--------")
statDesc(datasetNormalizzato)
print("------END -STATISTICHE DESCRITTIVE SUI DATI NORMALIZZATI-------")
print("-------------------TEST DI LINEARITÀ---------------------------")
print("--------------CALCOLO DELLA CORRELAZIONE-----------------------")
CalcCor(datasetNormalizzato,meth = "pearson")
print("------------------END CALCOLO DELLA CORRELAZIONE---------------")
#c'è correlazione positiva
#creo la retta di regressione per ogni variabile indipendente e dipendente
testLinearita(datasetNormalizzato)
print("--------------.-FINE TEST DI LINEARITÀ-------------------------")
print("----------------------OMOSCHEDASTICITÀ-------------------------")
omoschedasticita(datasetNormalizzato)
print("-----------------FINE OMOSCHEDASTICITÀ-------------------------")

#ipotesi nulla accettata (p-value>0.05), quindi non c'è omoschedasticità e potrebbe esserci eteroschedasticità
fm <- lm(datasetNormalizzato$Effort~ datasetNormalizzato$Input+datasetNormalizzato$Output+datasetNormalizzato$Enquiry
         +datasetNormalizzato$File+datasetNormalizzato$Interface)
gvlma(x = fm)
#summary(fm)
#accettiamo l'ipotesi nulla, cioè non c'è omoschedasticità
plot(resid(fm))
dens<-density(resid(fm))
plot(dens)
polygon(dens,border = "blue",col = "red")

#plot dei residui
print("------------------------STEPWISE--------------------------------")
selected_variables<-stepWiseTest(dataset)
print(paste("Selected Variables =>", toString(selected_variables)))
print("----------------------------END STEPWISE------------------------")
print(summary(fm))
print("-------------VERIFICA IPOTESI DI NORMALITÀ----------------------")
print("------------------------------SHAPIRO TEST----------------------")
print(shapiro.test(resid(fm)))
print("--------------------------END SHAPIRO TEST----------------------")
print("------------------------Durbin Watson TEST----------------------")
print(dwtest(fm))
print("--------------------END Durbin Watson TEST----------------------")
print("--------------------------DISTANZA DI COOK----------------------")
cooksd <- cooks.distance(fm)
print(cooksd)
sample_size <- nrow(datasetNormalizzato)
plot(cooksd, pch="*", cex=1, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 4/sample_size, col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>4/sample_size, names(cooksd),""), col="red")  # add labels
print("-------------------------END DISTANCE COOK---------------------")
print("-----------------FINE IPOTESI DI NORMALITÀ---------------------")

print("------------------------STEPWISE-------------------------------")
selected_variables = stepWiseTest(dataset = datasetNormalizzato)
print(selected_variables)
print("--------------------END STEPWISE-------------------------------")
print("--------------------------K-FOLD-------------------------------")
kfold(datasetNormalizzato)

print("-------------------END K-FOLD----------------------------------")
print("----------------------HOLDOUT----------------------------------")
holdOut(datasetNormalizzato)
hol2(datasetNormalizzato)
print("------------------END HOLDOUT----------------------------------")
