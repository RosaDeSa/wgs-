#!/usr/bin/R Rscript

library(dplyr)
library(readr)


wkdir<-setwd("/mnt/novaseq/r.desantis/wgs/")
#setwd(wkdir)

multiqc <-"title: 'NGDX Variant Calling analysis'
subtitle: 'Costumer report'
intro_text: 'MultiQC reports summarise analysis results.' "


gg<-"extra_fn_clean_exts:
    - .gz
    - _R1
    - _R2
    - .markdup
    - .sorted
    - _markdup
    - _sorted
    - .fastq
    - .fq
    - .bam
    - _paired
    - _star_aligned
    - _fastqc
    - _trimmed
    - .refstats.txt
    - .ehist.txt
    - .trimstats.txt
    - type: remove
      pattern: '.sorted'
top_modules:
    - fastqc:
         name: 'FastQC'
         path_filters_exclude:
            - '*trimmed_fastqc*'
    - fastqc:
         name: 'FastQC after trimming'
         info: 'FastQC after applying TRIMMOMATIC.'
         path_filters:
            - '*trimmed_fastqc*'
         path_filters_exclude:
            - '*_unpaired_*'

table_columns_visible:
    FastQC:
        total_sequences: True
        percent_duplicates: False
        percent_gc: False
        avg_sequence_length: True
    FastQC after trimming:
        percent_duplicates: False
        total_sequences: True
        avg_sequence_length: True
        percent_gc: False
show_analysis_paths: False
show_analysis_time: False"
complete<-paste(gg, sep = "\n")

m_config<-paste(multiqc,gene_count,complete, sep = "\n")
write.table(m_config,file="Coverage_multiqc_config.yaml",sep="\t",col.names = FALSE, row.names = FALSE,quote=FALSE)

