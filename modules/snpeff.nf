
process snpeff {
     container 'docker://quay.io/biocontainers/snpeff:5.1--hdfd78af_2'
    echo true
    label 'snpeff'
    tag 'snpeff'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))        "snpeff/Annotation/$filename"
      else if (filename.indexOf("html"))     "snpeff/Annotation/$filename"
      else if (filename.indexOf("csv"))     "snpeff/Annotation/$filename"
      else null
   }


   input:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_haplotyper)
   path(fasta)

   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.snpEff.ann.vcf"), emit: snpeff
   path "${sample_id}.snpEff.html", emit: snpEff_Report
   path "${sample_id}.snpEff.csv" , emit: snpEff_csv
   path "${sample_id}.snpEff.txt" , emit: snpEff_txt
 
script:
"""

    snpEff \
        ${snpeff_db} \
        -csvStats ${sample_id}.snpEff.csv \
        -nodownload \
        ${cache} \
        -canon \
        -v \
        ${vcf} \
        > ${sample_id}.snpEff.ann.vcf
        snpEff_summary.html 


"""


}

