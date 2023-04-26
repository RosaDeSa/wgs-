//valutare se aggiungere
process applybsrq {
container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'applybsrq'
    tag 'applybsrq'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("bam"))   "GATK/applybsrq/$filename"
      else null
   }

    input:
    tuple val(sample_id), val(id_patient), val(gender),val(id_run), path(bam_markdup)
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_bqsr_spark)
    path(fasta)
    path(fai)

    output:

    tuple val(sample_id),  val(id_patient), val(gender),val(id_run), file("${sample_id}.bqsr.bam"), emit: bam_bqsr_ch // will be needed for Haplotyper, Manta
  

    script:
    """
    gatk ApplyBQSR -I ${sample_id}_markdup.bam -R $fasta -bqsr $${sample_id}.table -O ${sample_id}.bqsr.bam
  
    """
}
//else if (filename.endsWith("bam.bai"))     "GATK/applybsrq/$filename"
  //tuple val(name), file("${name}.bqsr.bam.bai"), emit: indexed_bam_bqsr
    //samtools index ${name}_bqsr.bam

