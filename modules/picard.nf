//picard

process picard {
     container 'docker://rosadesa/ampliseq:0.3'
    echo true
    label 'picard'
    tag 'picard'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("pdf"))   "picard/$filename"
      else if (filename.endsWith("txt"))     "picard/$filename"
      else if (filename.endsWith("bed"))     "picard/$filename"
      else if (filename.endsWith("dict"))     "picard/$filename"
      else if (filename.endsWith("interval_list"))     "picard/$filename"
      else null
   
   	}


    
 input:
 tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(aligned_bam_bai)
 path(gene_bed)


 output:
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_GCbias.{txt,pdf}"), emit: gc_bias_metrics
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_qualitycycle.{txt,pdf}"), emit: mean_quality_cycle
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_qualityscore.{txt,pdf}"), emit: score_distribution
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_{HS,aln,wgs}_metrics.txt"), emit: metrics
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_indexstat.txt"), emit: bamstat
 path("fasta_modified.dict"), emit: genome_dict
 path("list.interval_list"), emit: interval_list

     
script:

"""

java -jar /picard.jar CollectGcBiasMetrics --INPUT ${sample_id}.sorted.bam --OUTPUT ${sample_id}_GCbias.txt -CHART ${sample_id}_GCbias.pdf --SUMMARY_OUTPUT ${sample_id}_GCmetrics.txt -R /home/tigem/r.desantis/wgs/results/ref/index/genome.fa

java -jar /picard.jar MeanQualityByCycle --INPUT ${sample_id}.sorted.bam --OUTPUT ${sample_id}_qualitycycle.txt --CHART ${sample_id}_qualitycycle.pdf 

java -jar /picard.jar QualityScoreDistribution --INPUT ${sample_id}.sorted.bam --OUTPUT ${sample_id}_qualityscore.txt --CHART ${sample_id}_qualityscore.pdf 

java -jar /picard.jar CollectAlignmentSummaryMetrics -R /home/tigem/r.desantis/wgs/results/ref/index/genome.fa -I ${sample_id}.sorted.bam -O ${sample_id}_aln_metrics.txt 

java -jar /picard.jar BamIndexStats -I  ${sample_id}.sorted.bam > ${sample_id}_indexstat.txt

java -jar /picard.jar CreateSequenceDictionary --R /home/tigem/r.desantis/wgs/results/ref/index/genome.fa --O fasta_modified.dict 

java -jar /picard.jar BedToIntervalList --INPUT ${gene_bed} --OUTPUT list.interval_list --SD "fasta_modified.dict" 

java -jar /picard.jar CollectHsMetrics -I ${sample_id}.sorted.bam -O ${sample_id}_HS_metrics.txt -R /home/tigem/r.desantis/wgs/results/ref/index/genome.fa -BI "list.interval_list" -TI "list.interval_list"



"""

}



//

//java -jar /picard.jar BedToIntervalList --INPUT ${gene_bed} --OUTPUT list.interval_list --SD $params.outdir/picard/fasta_modified.dict 

//java -jar /picard.jar CollectHsMetrics -I ${sample_id}.sorted.bam -O ${sample_id}_HS_metrics.txt -R $params.outdir/ref/index/genome.fa -BI list.interval_list -TI list.interval_list

//java -jar picard.jar CollectWgsMetrics -I ${sample_id}.sorted.bam -O ${sample_id}_wgs_metrics.txt -R /home/tigem/r.desantis/wgs/results/ref/index/genome.fa --INTERVALS "list.interval_list"
