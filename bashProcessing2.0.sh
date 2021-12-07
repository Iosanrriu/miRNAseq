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
    #docker run -e SRA=SRR114482$i -v $pathfastq:/root/ncbi/public/sra 66ca1b570a7a && echo "$SRA"' sra->fastq succesfully' || echo  "$SRA"' fail to donwload'
    
#>>>>>>>triming of files <Cutadapt>

    docker run -e SRA=SRR114482$i -e settings -v $pathfastq:/mnt 91e48802e6a3 && echo "$SRA"' succesfully trimmed! ' || echo  "$SRA"' failure to trim '
done

#>>>>>>>list of files to be align with their barcode

ls $pathfastq  -1 > $pathfastq/config0.txt && grep "trimmed" $pathfastq/config0.txt > $pathfastq/config1.txt && sed -i -e 's/^/\/mnt\//' $pathfastq/config1.txt 
#                   <agraga el sufijo si no config no va a cumplir con el formato que exige miRDeep2>
cut -c14-16 $pathfastq/config1.txt>$pathfastq/test2.txt && paste -d' ' $pathfastq/config1.txt $pathfastq/test2.txt > $pathfastq/config.txt && rm $pathfastq/config0.txt $pathfastq/test2.txt $pathfastq/config1.txt



#>>>>>>>alignment using <miRDeep2> 
pathfastq=/mnt/d/QuickMIRSeq/PRJNA201039_SRP022043/run1

time docker run -e command='mapper.pl /mnt/config.txt -d -e -m -h -p /mnt/index/hsa_GRCh38 -s /mnt/reads.fa -t /mnt/reads_vs_genome.arf' -v $pathIndex:/mnt/index -v $pathfastq:/mnt ef95d04458b6
time docker run -e command='quantifier.pl -d -g 1 -j -c /mnt/config.txt -p /mnt/index/hairpin.fa -m /mnt/index/mature.fa -t hsa -r /mnt/reads.fa' -v $pathIndex:/mnt/index -v $pathfastq:/mnt ef95d04458b6

#command1='mapper.pl /mnt/config.txt -d -e -m -h -p /mnt/index/hsa_GRCh38 -s /mnt/reads.fa -t /mnt/reads_vs_genome.arf'
#command2='quantifier.pl -d -g 1 -j -c /mnt/config.txt -p /mnt/index/hairpin.fa -m /mnt/index/mature.fa -t hsa -r /mnt/reads.fa'

#>>>>>>>diferential expresion

#R script 

# sort outut file?
