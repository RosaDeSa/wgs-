#!/usr/bin/R Rscript

library(dplyr)
library(readr)
#installare queste due library nel docker file
#togliere il commento da queste due library per non avere messaggi di conflicts
#library(testthat)
#library(assertive, warn.conflicts = FALSE)

#wkdir<- getwd()
#setwd(wkdir)
#perc<-file.path(wkdir,"Percentage_cov_reads")
#setwd(perc)

#modificare in nextflow le directory degli output, non conviene fare molto sottocartelle-RIORGANIZZA RESULTS
#wkdir_fc<-setwd("/home/tigem/r.desantis/prova_amplicon/results/featureCounts/")
#perc<-file.path(wkdir_fc,"coverage_stat")
#setwd(perc)
#perc<-setwd("/home/tigem/r.desantis/prova_amplicon/results/featureCounts/coverage_stat/")
perc<-setwd("/mnt/novaseq/r.desantis/wgs/results/featureCounts")
#df_perc <- list.files(perc, pattern=".base.coverage.perc.txt$")
df_perc <- list.files(pattern=".base.coverage.perc.txt$") %>%
  #lapply(read_delim) %>%
  lapply(read.table) %>%
  bind_rows


#median<-file.path(wkdir_fc,"calculator/")
#setwd(median)
#median<-setwd("/home/tigem/r.desantis/prova_amplicon/results/featureCounts/calculator/")
#median<-setwd("/home/tigem/r.desantis/onlytumor/results/featureCounts/")
#df_median <- list.files(median, pattern="_median.txt$")
#df_median <- list.files(pattern="_median.txt$") %>%
#  lapply(read.table) %>%
#  bind_rows
#colnames(df_median)<- c("Sample","Median")

#wkdir_vc<-setwd("/home/tigem/r.desantis/prova_amplicon/results/VEP")
#Variants<-file.path(wkdir_vc,"VariantCalling")
#setwd(Variants)
    Variants<-setwd("/mnt/novaseq/r.desantis/wgs/results/GATK")
    #df_all_variants <- list.files(Variants, pattern="_all_variants.tsv$")
    #df_all_variants <- list.files(pattern="_all_variants.tsv$") %>%
    #lapply(read.table) %>%
    #bind_rows
#colnames(df_all_variants)<- c("Sample","all_variants")

#df_filtered_variants <- list.files(Variants, pattern="_filtered_variants.tsv$")
df_filtered_variants <- list.files(pattern="_filtered.vcf$") %>%
  lapply(read.table) %>%
  bind_rows
#colnames(df_filtered_variants)<- c("Sample","filtered_variants")

#final <- df_median %>% 
#inner_join(df_perc,by = "V1") %>% 
#inner_join(df_all_variants , by ="V1") %>% 
#inner_join(df_filtered_variants, by =c("V1"))

wkdir<-setwd("/mnt/novaseq/r.desantis/wgs/results/")
#setwd(wkdir)

multiqc <-"title: 'NGDX Variant Calling analysis'
subtitle: 'Costumer report'
intro_text: 'MultiQC reports summarise analysis results.' "


gene_count<-paste("report_header_info:
     - Contact E-mail: 'service@ngdx.eu'
     - Sequencing Platform: 'Novaseq 6000'
     - Sequencing Setup: '2x150'
custom_data:
    my_genstats:
          plot_type: 'generalstats'
          pconfig:
              - Median_cov_per_base:
                  min: 0
                  format: '{:02d}'
              - Coverage_1x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:03d}'
              - Coverage_10x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - Coverage_20x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - Coverage_30x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - Coverage_50x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - Coverage_100x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - Coverage_150x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - Coverage_300x:
                  min: 0
                  max: 100
                  scale: 'RdYlGn'
                  suffix: '%'
                  format: '{:02d}'
              - All_Variants:
                  min: 0
                  format: '{:02d}'
              - Filtered_Variants:
                  min: 0
                  format: '{:02d}'
          data:")
          
complete<-""
for (i in 1:length(final$V1)){
  gene<-paste0("              ",final$V1[i]," :\n                Median_cov_per_base: ",final[i,10])
  st1<-paste0("\n                ","Coverage_1x: ",final[i,14])

  st<-paste0("\n                ","Coverage_10x: ",final[i,15])

  st2<-paste0("\n                ","Coverage_20x: ",final[i,16])
  tre<-paste0("\n                ","Coverage_30x: ",final[i,17])
  cinque<-paste0("\n                ","Coverage_50x: ",final[i,18])
  dieci<-paste0("\n                ","Coverage_100x: ",final[i,19])
  qc<-paste0("\n                ","Coverage_150x: ",final[i,20])
  pe<-paste0("\n                ","Coverage_300x: ",final[i,21])
  allv<-paste0("\n                ","All_Variants: ",final[i,22])
  fv<-paste0("\n                ","Filtered_Variants: ",final[i,23], "\n")

  complete<-paste(complete,gene,st1,st,st2,tre,cinque,dieci,qc,pe,allv,fv)
}
gg<-"extra_fn_clean_exts:
    - .gz
    - _R1
    - _R2
    - .deduped
    - .sorted
    - _deduped
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
complete<-paste(complete,gg, sep = "\n")

m_config<-paste(multiqc,gene_count,complete, sep = "\n")
write.table(m_config,file="Coverage_multiqc_config.yaml",sep="\t",col.names = FALSE, row.names = FALSE,quote=FALSE)

