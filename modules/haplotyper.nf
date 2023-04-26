//Call germline SNPs and indels via local re-assembly of haplotypes
process haplotypecall {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'haplotypecall'
    tag 'haplotypecall'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))     "GATK/$filename"
      else null
   }


   input:

   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(indexed_bam_bqsr)
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_bqsr_spark)
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(bam_bqsr_ch)
   path(fai)
   path(genome_dict)
   //path(gatk_dict)
   path(known_dbsnp)
   path(known_dbsnp_tbi)
   path(fasta)
   path(know_1000G)
   path(know_1000G_tbi)
   path(known_mills)
   path(known_mills_tbi)

  
    

   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_haplotype.vcf"), emit:  gatk_haplotyper


   script:

   """
      
       gatk HaplotypeCaller \\
        --input ${sample_id}.bqsr.bam \\
        --output ${sample_id}_haplotype.vcf \\
        --reference $fasta \\
        --dbsnp ${known_dbsnp} \\
        --tmp-dir . \\
   """
}

