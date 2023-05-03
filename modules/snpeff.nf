
process snpeff {
     container 'docker://quay.io/biocontainers/snpeff:5.1--hdfd78af_2'
    echo true
    label 'snpeff'
    tag 'snpeff'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))        "snpeff/Annotation/$filename"
      else if (filename.indexOf("html"))     "snpeff/Annotation/$filename"
      else null
   }


   input:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_haplotyper)
   path(fasta)

   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.VEP.ann.vcf"), emit:vep
   path "${sample_id}.VEP.summary.html", emit: vepReport
 
script:
"""

    vep \
        -i ${gatk_haplotyper} \
        -o ${sample_id}.VEP.ann.vcf \
        --assembly $fasta \
        --everything \
        --filter_common \
        --format vcf \
        --per_gene \
        --stats_file ${sample_id}.VEP.summary.html \
        --total_length \
        --offline   \
        --dir_cache "~/.vep" \
        --vcf

"""



}



    input:
    tuple val(sample_id), file(vcf) 
    file(data_dir) 
    val snpeff_db

    output:
    tuple file("${sample_id_reduced}.snpEff.genes.txt"), file("${sample_id_reduced}.snpEff.html"), file("${sample_id_reduced}.snpEff.csv"), emit: snpeff_report
    tuple val(sample_id_reduced), file("${sample_id_reduced}.snpEff.ann.vcf"), emit: snpeff_vcf
    
    // Note: anything from Haplotyper ?
    script:
    sample_id_reduced = sample_id.minus("_bqsr")
    cache = (params.snpeff_cache) ? "-dataDir \${PWD}/${data_dir}" : ""
    """
    snpEff -Xmx8g \
        ${snpeff_db} \
        -csvStats ${sample_id_reduced}.snpEff.csv \
        -nodownload \
        ${cache} \
        -canon \
        -v \
        ${vcf} \
        > ${sample_id_reduced}.snpEff.ann.vcf
    mv snpEff_summary.html ${sample_id_reduced}.snpEff.html
    """
}

process SNPEFF_VERSION {
    tag "SnpEff version"
    publishDir $params.ou