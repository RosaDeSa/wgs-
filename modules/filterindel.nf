//Filter indel
process filterindel {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'filterindel'
    tag 'filterindel'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))     "GATK/$filename"
      else null
   }


   input:

   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(select_indel)
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
  tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_filtered_indel.vcf"), emit:  filtered_indels


   script:

   """
    gatk VariantFiltration \\
    -R $fasta \\
    -V ${sample_id}_indel.vcf \\
    -O ${sample_id}_filtered_indel.vcf \\
    -filter-name "QD_filter" -filter "QD < 2.0" \\
    -filter-name "FS_filter" -filter "FS > 60.0" \\
    -filter-name "MQ_filter" -filter "MQ < 40.0" \\
    -genotype-filter-expression "DP < 10" \\
    -genotype-filter-name "DP_filter" \\
    -genotype-filter-expression "DP < 10" \\
    -genotype-filter-name "DP_filter" \\
    -genotype-filter-expression "GQ < 10" \\
    -genotype-filter-name "GQ_filter" \\

   """
}