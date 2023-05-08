
process vep {
     container 'docker://giusmar/vep:0.0.1'
    echo true
    label 'vep'
    tag 'vep'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("VEP.ann.vcf"))        "VEP/$filename"
      else if (filename.indexOf("html"))     "VEP/$filename"
      else null
   }


   input:
   //tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(bcftools)
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_haplotyper)
   path(fasta)

   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.VEP.ann.vcf"), emit:vep
   path "${sample_id}.summary.html", emit: vepReport
 
script:
"""

        -i ${gatk_haplotyper} \\
        -o ${sample_id}.VEP.ann.vcf \\
        $fasta \\
        --assembly GRCh38 \\
        --vcf \\
        --mane \\
        --symbol \\
        --cache \\
        --show_ref_allele \\
        --assembly GRCh38 \\
        --per_gene \\
        --dir_cache "/home/tigem/r.desantis/.vep" \\
        --cache_version 102 \\
        --canonical \\
        --stats_file ${sample_id}.summary.html\\
        --check_existing \\
        --no_intergenic \\
        --af \\
        --af_gnomad 

        
"""


}
/*


    vep \\
        -i ${bcftools} \\
        -o ${sample_id}.VEP.ann.vcf \\
        $fasta \\
        --assembly GRCh38 \\
        --vcf \\
        --mane \\
        --symbol \\
        --cache \\
        --show_ref_allele \\
        --assembly GRCh38 \\
        --per_gene \\
        --dir_cache "/home/tigem/r.desantis/.vep" \\
        --cache_version 102 \\
        --canonical \\
        --stats_file ${sample_id}.summary.html\\
        --check_existing \\
        --no_intergenic \\
        --af \\
        --af_gnomad 


*/