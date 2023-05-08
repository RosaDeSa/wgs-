process bcftools {
    container 'docker://staphb/bcftools'
    echo true
    label 'bcftools'
    tag 'bcftools'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))     "bcftools/$filename"
      else null
   }


   input:
  tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_haplotyper)

  

   output:
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("*.ann.vcf"), emit: bcftools



   script:

 """

bcftools annotate -c ID -a ${gatk_haplotyper} > ${sample_id}.ann.vcf

"""

}


