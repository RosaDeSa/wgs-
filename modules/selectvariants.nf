//select variants
process selectvariants {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'selectvariants'
    tag 'selectvariants'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))     "GATK/$filename"
      else null
   }


   input:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(filtered_snps)
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(filtered_indels)
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
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_ready-snps.vcf"), emit:  ready_snp
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_ready-indel.vcf"), emit:  ready_indel


   script:

   """
    gatk SelectVariants \\
    —exclude-filtered \\
    -V ${sample_id}_filtered_snps.vcf\\
    -O ${sample_id}_ready-snps.vcf \\
    
    gatk SelectVariants \\
    —exclude-filtered \\
    -V ${sample_id}_filtered_indel.vcf\\
    -O ${sample_id}_ready-indel.vcf \\


   """
}