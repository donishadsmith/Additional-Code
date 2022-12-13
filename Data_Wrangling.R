pacman::p_load(plyr,dplyr)
#Importing spss dataset
data = Hmisc::spss.get("~/NeuralMechanisms_SharedData.sav",use.value.labels = F)
#Creating project dataset with ID, sex, age, Ethnicity, Education, & Income
#project = data.frame(data[c(1,236,3,7,28,29)])
#missdata = data[520]
#miss = which(is.na(missdata$Sex.2))
#data = data[-miss,]
project_pre = data.frame(data[c('Physics.ID', 'D1.1')]) 
project_post = data.frame(data[c('Physics.ID','D1.2')]) 

#Rownames are now participant ID
colnames(project_pre) = c('ID','Age')
colnames(project_post) = c('ID','Age')


#rownames(project) = project$ID

#All four anxiety measures are being placed into their own dataframe
#Science scale is the only scale that has some non-science related items.
#Remove non science questions in items
science_pre = data.frame(data[c(167:210)]); science_pre  = science_pre  %>% select(-starts_with("NScA"))
math_pre = data.frame(data[c(211:235)])
beck_pre = data.frame(data[c(51:71)])

science_post = data.frame(data[c(451:494)]); science_post  = science_post  %>% select(-starts_with("NScA")); science_post = science_post[1:22]
math_post = data.frame(data[c(495:519)])
beck_post = data.frame(data[c(335:355)])


iq = readxl::read_xlsx("~/wais-iv_rescored.xlsx")
iq_pre = iq[(iq$Enrollment.ID %in% project_pre$ID),]
project_pre$ID - iq_pre$Enrollment.ID
iq_pre %>% select(ends_with("I1"))
project_pre = cbind(project_pre,iq_pre %>% select(ends_with("I1")) )

iq_post = iq[(iq$Enrollment.ID %in% project_post$ID),]
project_post$ID - iq_post$Enrollment.ID
iq_post %>% select(ends_with("I2"))
project_post$ID - iq_post$Enrollment.ID
project_post = cbind(project_post,iq_post %>% select(ends_with("I2")) )

#Imwais-iv_rescored.xlsxporting Years
#behave = read.csv("~/BehavioralData.csv");rownames(behave) = behave$Enrollment.ID
#a = project[!(rownames(project) %in% rownames(behave)),] 
#temp = matrix(nrow = nrow(a), ncol = ncol(behave)) %>% data.frame()
#rownames(temp) = rownames(a);temp[,1] = as.numeric(rownames(a));colnames(temp) = colnames(behave)
#behave = rbind(behave, temp);behave = behave[(rownames(project)),]
#Strategy: there is a discrepancy in the participation IDs in the behavioral and fmri data.
#So, to ensure that the correct student is being assigned their fmri or behavioral values,
#their numerical IDs are assigned to rownames and the rownames are sutracted from each other for 
#both datasets. If a series of zeroes is produces, then everything is fine.
#which(as.numeric(rownames(project)) - as.numeric(rownames(behave)) > 0)
#project$Years = behave$Strt.Level

which(beck_pre[1:ncol(beck_pre)] > 3, arr.ind = T)
which(science_pre[1:ncol(science_pre)] > 4, arr.ind = T)
which(math_pre[1:ncol(math_pre)] > 4, arr.ind = T)

which(beck_post[1:ncol(beck_post)] < 0, arr.ind = T)
which(science_post[1:ncol(science_post)] < 0, arr.ind = T)
which(math_post[1:ncol(math_post)] < 0, arr.ind = T)

#Mean substitution
for(i in 1:ncol(science_pre)) { 
  science_pre[ , i][is.na(science_pre[ , i])] <- mean(science_pre[ , i], na.rm = TRUE)}
for(i in 1:ncol(beck_pre)) { 
  beck_pre[ , i][is.na(beck_pre[ , i])] <- mean(beck_pre[ , i], na.rm = TRUE)}
for(i in 1:ncol(math_pre)) { 
  math_pre[ , i][is.na(math_pre[ , i])] <- mean(math_pre[ , i], na.rm = TRUE)}

for(i in 1:ncol(science_post)) { 
  science_post[ , i][is.na(science_post[ , i])] <- mean(science_post[ , i], na.rm = TRUE)}
for(i in 1:ncol(beck_post)) { 
  beck_post[ , i][is.na(beck_post[ , i])] <- mean(beck_post[ , i], na.rm = TRUE)}
for(i in 1:ncol(math_post)) { 
  math_post[ , i][is.na(math_post[ , i])] <- mean(math_post[ , i], na.rm = TRUE)}


project_pre$SA_pre= rowSums(science_pre[1:ncol(science_pre)]) 
project_pre$BK_pre= rowSums(beck_pre[1:ncol(beck_pre)])  
project_pre$MA_pre= rowSums(math_pre[1:ncol(math_pre)]) 

project_post$SA_post= rowSums(science_post[1:ncol(science_post)])
project_post$BK_post= rowSums(beck_post[1:ncol(beck_post)]) 
project_post$MA_post= rowSums(math_post[1:ncol(math_post)]) 

#z-scored
#project_pre$SA_pre= rowSums(science_pre[1:ncol(science_pre)])  %>% scale(center = T, scale = T) %>% as.numeric()
#project_pre$BK_pre= rowSums(beck_pre[1:ncol(beck_pre)])  %>% scale(center = T, scale = T) %>% as.numeric()
#project_pre$MA_pre= rowSums(math_pre[1:ncol(math_pre)])  %>% scale(center = T, scale = T) %>% as.numeric()

#project_post$SA_post= rowSums(science_post[1:ncol(science_post)])  %>% scale(center = T, scale = T) %>% as.numeric()
#project_post$BK_post= rowSums(beck_post[1:ncol(beck_post)])  %>% scale(center = T, scale = T) %>% as.numeric()
#project_post$MA_post= rowSums(math_post[1:ncol(math_post)])  %>% scale(center = T, scale = T) %>% as.numeric()

colnames(project_pre)
project_pre$Time = rep('pre',nrow(project_pre) )
project_post$Time = rep('post',nrow(project_post) )

names = c('ID','age', "vci", "pri", "wmi", "psi", "sa", "bk", "ma", "Time")
colnames(project_pre) = names
colnames(project_post) = names
project = project_pre; colnames(project) = names

project = rbind(project, project_post)

project = project[order(project$ID),]
project$age = as.numeric(project$age)

table = read.table("~/Downloads/participants.tsv", sep = "\t")
colnames(table) = table[1,];  table = table[2:nrow(table),]
table = rbind(table,table); table = table[order(table$participant_id),]


subjects = c()

for(subject in table$participant_id){
  x = unlist(strsplit(subject,NULL))
  x = length(numeric(paste0(x[5], x[6], x[7])))
  subjects = c(subjects,x)
}


available = project[(project$ID %in% subjects),]
available[237:242,] = NA
miss = which(!(subjects %in% available$ID))
available[237:242,1] = subjects[miss]
available = available[order(available$ID),]

table = cbind(table[1:3],available[c(2,4,5,7:9)])


modeling = table[which(table$group == 'modeling'),]
traditional = table[which(table$group == 'traditional'),]

readr::write_tsv(table,file = "~/participants.tsv", append = T, col_names = T)

readr::write_tsv(modeling,file = "~/participants_modeling.tsv", append = T, col_names = T)

readr::write_tsv(traditional,file = "~/participants_traditional.tsv", append = T, col_names = T)
