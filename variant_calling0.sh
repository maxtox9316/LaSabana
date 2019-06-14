#!/usr/bin/env bash
# Index using bwa, align, take sam from alignment and call variants
for f in ~/data/trimmed_fastq_small/sub/*_1*
do
  name=$(basename $f _1.trim.sub.fastq)
  echo $name
  bwa index ~/data/ref_genome/GCA_000017985.1_ASM1798v1_genomic.fna
  bwa mem ~/data/ref_genome/GCA_000017985.1_ASM1798v1_genomic.fna \
  ~/data/trimmed_fastq_small/sub/${name}_1.trim.sub.fastq \
  ~/data/trimmed_fastq_small/sub/${name}_2.trim.sub.fastq > \
  ~/results/alignment/${name}.sam
  echo "BWA done"
  samtools view -S -b ~/results/alignment/${name}.sam | \
  samtools sort -o ~/results/alignment/${name}.sorted.bam
  samtools index ~/results/alignment/${name}.sorted.bam
  echo "Samtool done"
  bcftools mpileup -O b -o ~/results/${name}.bcf -f \
  ~/data/ref_genome/GCA_000017985.1_ASM1798v1_genomic.fna \
  ~/results/alignment/${name}.sorted.bam
  bcftools call --ploidy 1 -m -v -o ~/results/${name}_variants.bcf \
  ~/results/${name}.bcf
  vcfutils.pl varFilter ~/results/${name}_variants.bcf >\
  ~/results/${name}_final_variants.bcf
  grep -v "^#" ~/results/${name}_final_variants.bcf | wc
  echo "Done"
  echo $f
done
