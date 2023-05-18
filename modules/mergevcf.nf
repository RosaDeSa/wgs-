//mergevcf
process mergevcf {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'mergevcf'
    tag 'mergevcf'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))     "GATK/$filename"
      else null
   }


   input:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(ready_snp)
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(ready_indel)


    
   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_filtered.vcf"), emit:  filtered_vcf



   script:

   """

    gatk MergeVcfs \\
    -I ${ready_snp} \\
    -I ${ready_indel} \\
    -O ${sample_id}_filtered.vcf

   """
}













