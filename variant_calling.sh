# Variant Cit+

cp ~/.backup/untrimmed_fastq/*fastq.gz .
fastqc *fastq.gz
mkdir -p ~/results/fastqc_untrimmed
mv *zip ~/results/fastqc_untrimmed/
mv *html ~/results/fastqc_untrimmed/

# Unzip fastqc
for filename in *.zip; do unzip $filename; done

