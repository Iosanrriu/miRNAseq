#!/bin/bash

#>>>>>>>definir rutas abosultas a las carpetas donde se almancenaran los indices de bowtie y los fastq

pathfastq=/mnt/c/Users/espin/Desktop/dataSets/GSE147714
pathIndex=/mnt/c/Users/espin/Desktop/index
settings='--cores=6 -a TGGAATTCTCGGGTGCCAAGG -m 17 --quality-cutoff 32'
export settings
export pathfastq
export pathIndex

#>>>>>>>download and transform sra to fastq files <sratoolkit>

for ((i=42;i<=53;i++)); do
    docker run -e SRA=SRR114482$i -v $pathfastq:/root/ncbi/public/sra 66ca1b570a7a && echo "$SRA"' sra->fastq succesfully' || echo  "$SRA"' fail to donwload'
    
#>>>>>>>triming of files <Cutadapt>

    docker run -e SRA=SRR114482$i -e settings -v $pathfastq:/mnt 91e48802e6a3 && echo "$SRA"' succesfully trimmed! ' || echo  "$SRA"' fail to trim '
done

#>>>>>>>list of files to be align with their barcode

ls $pathfastq  -1 > $pathfastq/config0.txt && grep "trimmed" $pathfastq/config0.txt > $pathfastq/config.txt && sed -i -e 's/^/\/mnt\//' $pathfastq/config.txt && rm $pathfastq/config0.txt


#                   <falta agragar el sufijo!!!!!!>


#>>>>>>>alignment using <miRDeep2>

docker run -v $pathIndex:/mnt/index -v $pathfastq:/mnt 92deee3a7a3f #-it 9a61a41ee404 #original hayque intalar unas librerias

#>>>>>>>diferential expresion

R script

# sort outut file?
