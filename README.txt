# este documento busca explicar el pipeline de procesamiento de muestras de miRNAseq
# Para la descarga de todos los contenedores descritos a continuacion se puede correr el schipt installation_docker_Basics_miRNAseq.sh en el repositorio

#autor Nicolas Espinosa W.<nicolas@neurognos.com>

(I)>>>>>DOWNLOAD AND TRANSFORMATION.

Los archivos de secuenciacion de RNAseq consisten en millones de lineas de lectura de secuenciacion, cada una con la secuencia de nucleotidos secuenciada y con otra linea de mismo largo con el respectivo score de calidad de cada nucleotido secuenciado generalmente en codigo phred 33. Estos archivos tienden a pesar varios cientos de megabytes en formato sra o 'raw data archive', distinto a los fastq que llegan a pesar 2-5 gigabytes, por lo que es ideal descargar en sra para agilizar el proceso de descarga.

Para esto se creó un contenedor Docker basado en la imagen de dockerhub staphb/sratoolkit, el cual contiene sratoolkit(V2.9.2) para descargar archivos sra y transformalos a fastq en local. el contenedor puede ser ejecutado en cualquier equipo que contenga la imagen del contenedor.


contenedor-> 1) El contenedor recive medieante el paramentro -e un codigo SRA y secuencialmente descarga ese archivo desde NCBI usando 'prefetch' 
	     2) Seguidamente si la descarga es exitosa se ejecuta dastq-dump sobre el mismo sra descargado, obteniendose el archvo fastq, 
	     3) Si es exitosa la transofrmasion entonces se remueve el archivo sra.
	     4) Para más informacion revisar dockerfile en el reposiorio <https://github.com/Iosanrriu/miRNAseq/tree/main/Dockerfiles/sratoolkit>

modo de uso:

>>>>>>
pathfastq=/mnt/c/Users/espin/Desktop/dataSets/GSE147714
export pathfastq
for ((i=42;i<=53;i++)); do
    SRA=SRR114482$i
    docker run -e SRA -v $pathfastq:/root/ncbi/public/sra 66ca1b570a7a && echo "$SRA"' sra->fastq succesfully' || echo  "$SRA"' fail to donwload'
done
>>>>>>

EXPLICACION:
-Como buena practica se creó un directorio 'dataSets' y dentro de este un directorio 'GSE147714', aquí se almacenaran las muestras que se descarguen de ese proyecto en GEO. se recomienta tener una carpeta por cada conjunto de muestras y guardar la metadata asociada a ese proyecto en el mismo directorio.
-pathfastq es una variable que funciona como ruta absoluta al directorio donde se quieren almacenar los archivos fastq, esta debe ser editada!
Las muestras que se quieren son desde la SRR11448242 a la SRR11448253 de forma que i recorre desde 43 a 53, si se quiere descargar otro conjunto de muestras se debe cambiar el codigo SRA y el rango de {i} NOTA: si se desea descargar SRR40290 al SRR40310 reemplazar SRA=SRR40$i con i entre (290-310)


(II)>>>>>TRIMMING.

El proceso de trimming permite quitar adaptadores y quedarnos con las lecturas de secuencaicion que cumplen con un minimo de calidad aceptado por el usuario, una inspeccion de los archivos usando fastQC puede ser necesaria para poder confirmar que los parametros utilziados fueron suficientes para alcanzar las calidades requerida. Algunos archivos pueden encontrarse sin adaptadores y listo para ser alineados por lo que puede omitirse este paso si los datos cumplen los estandares de calidad.

Para esto se creó un contenedor Docker basado en la imagen de dockerhub kfdrc/cutadapt, que tiene ubuntu con cutadapt(V2.5) instalado junto con sus dependencias.

contenedor-> 1) 'settings' permite variar los parametros segun el manual de cutadapt <https://cutadapt.readthedocs.io/en/stable/guide.html>
	     2) Recive un SRR*.fastq y entrega un SRR*_trimmed.fastq el la misma carpeta donde se ecuentran los fastq originales 
	     3) Para más informacion revisar dockerfile en el reposiorio <https://github.com/Iosanrriu/miRNAseq/tree/main/Dockerfiles/cutadapt>

modo de uso:

>>>>>>
pathfastq=/mnt/c/Users/espin/Desktop/dataSets/GSE147714
settings='--cores=6 -a TGGAATTCTCGGGTGCCAAGG -m 17 --quality-cutoff 32'
export settings
export pathfastq
for ((i=42;i<=53;i++)); do
    docker run -e SRA=SRR114482$i -e settings -v $pathfastq:/mnt 91e48802e6a3 && echo "$SRA"' succesfully trimmed! ' || echo  "$SRA"' fail to trim '
done
>>>>>>

EXPLICACION:


(III)>>>>>ALIGMENT & QUANTIFICATION.

En RNAseq el Alineamiento permite asociar lecturas(reads) a un genoma de referencia para determinar a que gen corresponde dicha secuencia, lo mismo se aplica para una referencia de miRNAs con la consideracion de que un gen puede tener varios cientos de bp mientras que los miRNAs tienen ~21-25bp, bowtie(v1.1.2) es el alineador que utiliza miRDeep2 y se comporta bien alineando secuencias cortas. Posteriormente se genera la cuantificacion de read por miRNA y se obtiene una matrix de conteo por muestra.
Para esto se creó un contenedor Docker basado en la imagen de dockerhub forrestzhang/docker-mirdeep2, que tiene miRDeep2 preinstalado sobre Ubuntu.

contenedor-> 1) pathfast es la ruta donde se encuentran los archivos trimmeados, en este tambien se encuentra un archivo config.txt que tiene la ruta individual de cada fastq y un sufico de 3 digitos separado por un ' '.
	     2) pathIndex es una ruta al directorio donde estan los indices de bowtie, está el genoma de referencia de humano (archivos .ebwt) y los archivos mature.fa y hairpin.fa de miRBase (v21)
	     3) mapper.pl entrega: archivo reads.fa, reads_vs reads_vs_genome.arf, mapper.log_XXX (x2) y bowtie.log
	     4) quantigier.pl usa los archivos de mapper.pl y entrega: directorio Aligments, XXX_Processed_read_counts_per_gene_all_conditions.csv donde se encuentran los conteos por miRNA asociado a precursor(hairpin).
	     4) Para más informacion revisar dockerfile en el reposiorio <https://github.com/Iosanrriu/miRNAseq/tree/main/Dockerfiles/miRDeep2>

modo de uso:

>>>>>>
pathfastq=/mnt/c/Users/espin/Desktop/dataSets/GSE147714
pathIndex=/mnt/c/Users/espin/Desktop/index
export pathfastq
export pathIndex

time docker run -e command='mapper.pl /mnt/config.txt -d -e -m -h -p /mnt/index/hsa_GRCh38 -s /mnt/reads.fa -t /mnt/reads_vs_genome.arf' -v $pathIndex:/mnt/index -v $pathfastq:/mnt ef95d04458b6
time docker run -e command='quantifier.pl -d -g 1 -j -c /mnt/config.txt -p /mnt/index/hairpin.fa -m /mnt/index/mature.fa -t hsa -r /mnt/reads.fa' -v $pathIndex:/mnt/index -v $pathfastq:/mnt ef95d04458b6

>>>>>>

(IV)>>>>>NORMALIZATION.
