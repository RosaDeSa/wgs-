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

bcftools +fill-tags ${gatk_haplotyper} -Ob -o ${sample_id}.ann.vcf  -- -t QD,FS,MQ


"""

}

//aggiungere le informazioni al vcd di quality depth, fisher test e  RS mapping quality con bcftools
