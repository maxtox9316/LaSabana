#!usr/bin/env bash
# Sript to trim  fastqs with trimmomatic

for f in ${1}/*_1.fastq.gz 
do
  name=$(basename ${f} _1.fastq.gz)
  trimmomatic PE -threads 4\
  ${1}/${name}_1.fastq.gz \
  ${1}/${name}_2.fastq.gz \
  ${2}/${name}_1.trim.fastq.gz \
  ${2}/${name}_1.untrim.fastq.gz \
  ${2}/${name}_2.trim.fastq.gz \
  ${2}/${name}_2.untrim.fastq.gz \
  SLIDINGWINDOW:4:20 MINLEN:25\
  #ILLUMINACLIP:~/.miniconda3/pkgs/trimmomatic-0.38-0/share/trimmomatic-0.38-0/adapters/NexteraPE-PE.fa:2:40:15 
  ## Not working
done
