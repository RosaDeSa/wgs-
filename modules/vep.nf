
process vep {
     container 'docker://giusmar/vep:0.0.1'
    echo true
    label 'vep'
    tag 'vep'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("VEP.ann.vcf"))        "VEP/Annotation/$filename"
      else if (filename.indexOf("summary.html"))     "VEP/Annotation/$filename"
      else null
   }


   input:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(gatk_haplotyper)
   path(fasta)

   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.VEP.ann.vcf"), emit:vep
   path "${sample_id}.summary.html", emit: vepReport
 
script:
"""
    vep \\
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

//rimuovere integeniche con _no_intergenic
//vep --cache --merged --vcf --gene_phenotype --show_ref_allele --symbol --protein --biotype --plugin Phenotypes,file=/home/tigem/a.grimaldi/software/ensembl-vep/phenotypes.gff.gz,include_types=Gene --plugin
//perl \$vcftomaf --input-vcf ${gatk_haplotyper} --output-maf ${sample_id}.maf --vep-path /opt/vep/src/ensembl-vep/  --ncbi-build "GRCh38" --tumor-id ${sample_id} --vcf-tumor-id ${sample_id} --ref-fasta $fasta --cache-version 102
//vcftomaf="$baseDir/bin/vcftomaf.pl"
//perl \$vcftomaf --input-vcf ${gatk_haplotyper} --output-maf ${sample_id}.maf --vep-path /opt/vep/src/ensembl-vep/  --ncbi-build "GRCh38" --normal-id ${sample_id} --vcf-normal-id ${sample_id} --ref-fasta $fasta --cache-version 102

  
/*
    script:
    // TODO: pass in channel..
    genome = params.genome
    """
    mkdir ${sample_id}
    vep \
        -i ${vcf} \
        -o ${sample_id}.VEP.ann.vcf \
        --assembly ${genome} \
        --everything \
        --filter_common \
        --fork ${task.cpus} \
        --format vcf \
        --per_gene \
        --stats_file ${sample_id}.VEP.summary.html \
        --total_length \
        --offline   \
        --dir_cache "/.vep/" \
        --vcf
    rm -rf ${sample_id} 
    
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
        --dir_cache "/home/tigem/r.desantis/.vep" \
        --cache 102 \
        --vcf /
        --ncbi-build "GRCh38"*/

           //remove --offline   \