FROM kfdrc/cutadapt

MAINTAINER Nicolas E.W <espinosa_nicolas@hotmail.com> 1.0

CMD sra_in="$SRA".fastq && sra_out="$SRA"_trimmed.fastq && cutadapt $settings -o /mnt/$sra_out /mnt/$sra_in

