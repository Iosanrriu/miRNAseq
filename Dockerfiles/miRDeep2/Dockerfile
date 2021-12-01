FROM miasteinberg/mirdeep2

MAINTAINER Nicolas E.W <espinosa_nicolas@hotmail.com>

#Can't locate PDF/API2.pm in @INC (you may need to install the PDF::API2 module)
#CMD cpan PDF::API2
CMD cd /mnt
CMD time mapper.pl /mnt/config.txt -d -e -m -h -q -p /mnt/index/GRCh38/hsa_GRCh38 -s /mnt/reads.fa -t /mnt/reads_vs_genome.arf 
#CMD time quantifier.pl -d -j -g 2 -c /mnt/config.txt -p /mnt/index/hairpin_rna/hairpin_hsa.fa -m /mnt/index/mature_rna/mature_hsa.fa -r /mnt/reads.fa
CMD time miRDeep2.pl /mnt/reads.fa /mnt/index/GRCh38/hsa_GRCh38 /mnt/reads_vs_genome.arf /mnt/index/mature_rna/mature_hsa.fa -P none none 2>report.log 