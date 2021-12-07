FROM forrestzhang/docker-mirdeep2

MAINTAINER Nicolas E.W <espinosa_nicolas@hotmail.com>

#Can't locate PDF/API2.pm in @INC (you may need to install the PDF::API2 module)
#RUN cpan PDF::API2
WORKDIR /mnt
CMD $command

#CMD time miRDeep2.pl /mnt/reads.fa /mnt/index/GRCh38/hsa_GRCh38 /mnt/reads_vs_genome.arf /mnt/index/mature_rna/mature_hsa.fa -P none none 2>report.log 