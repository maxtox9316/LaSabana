#!/usr/bin/env bash

# Index using bwa, align, take sam from alignment and call variants Argument
# reference genome,
#$1 trimmed data ~/data/trimmed_fastq_small/sub/ $2 ~/data/ref_genome/GCA_000017985.1_ASM1798v1_genomic.fna
# boorarra esto

echo "Trimmed data directory ${1}"
echo "Reference genome  ${2}"
sleep 3

for f in ${1}*_1*
do
  name=$(basename $f _1.trim.sub.fastq)
  echo "Working on ${f}"
  spleep 3
  bwa index ${2}
  bwa mem ${2} ${1}/${name}_1.trim.sub.fastq ${1}/${name}_2.trim.sub.fastq > \
  ~/results/alignment/${name}.sam > outputBWA.out
  echo "BWA done!"
  samtools view -S -b ~/results/alignment/${name}.sam | \
  samtools sort -o ~/results/alignment/${name}.sorted.bam
  samtools index ~/results/alignment/${name}.sorted.bam
  echo "Samtools done!"
  bcftools mpileup -O b -o ~/results/${name}.bcf -f ${2} \
  ~/results/alignment/${name}.sorted.bam
  bcftools call --ploidy 1 -m -v -o ~/results/${name}_variants.bcf \
  ~/results/${name}.bcf
  echo "Bcftools Done!"
  vcfutils.pl varFilter ~/results/${name}_variants.bcf > \
  ~/results/${name}_final_variants.bcf
  grep -v "^#" ~/results/${name}_final_variants.bcf | wc
  sleep 3
done
