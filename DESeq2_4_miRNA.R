#DESeq2

library(ggplot2)
library(DESeq2)
#0. set working space


setwd("C:/Users/espin/Desktop/dataSets/GSE147714")
#from bash adquire the name of the data count

#1.1 Import & pre-process--------------------------
#output/miR.filter.Counts.csv

data_counts=read.csv('C3miRNAs_expressed_all_samples_1637767532.csv',header=TRUE)# no cambia nunca este nombre 
mirna= data_counts$X.miRNA
#ownames(data_counts)<-data_counts$miRNA
data_counts <-data_counts[ c(4:15) ]
#1.2 for control bond experiments count in a table
row.names(data_counts) <- NULL


metatable=read.csv('SraRunTable.txt',header = TRUE)
metatable['Run']<-colnames(data_counts)

row.names(metatable) <- NULL
sra=metatable['Run']
condicion=(metatable['source_name'])
tisue=metatable['tissue']

metadata<-data.frame(id=sra,dex=condicion,celltype=tisue)

dds<-DESeqDataSetFromMatrix(countData=data_counts, 
                            colData=metadata, 
                            design=~source_name)

dds<-DESeq(dds)
res<-as.data.frame(results(dds))
rownames(res)<-mirna

write.csv(res, file="DE_miRNA_GSE147714_2.csv")


