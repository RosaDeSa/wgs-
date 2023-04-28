
process vep {
     container 'docker://giusmar/vep:0.0.1'
    echo true
    label 'vep'
    tag 'vep'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))        "VEP/Annotation/$filename"
      else if (filename.indexOf("maf"))     "VEP/Annotation/$filename"
      else if (filename.indexOf("tsv"))     "VEP/Annotation/$filename"
      else null
   }


   input:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(subset_panel)
   path(fasta)

   output:
   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.maf"), emit:vep
 
script:
"""
vcftomaf="$baseDir/bin/vcftomaf.pl"
perl \$vcftomaf --input-vcf ${subset_panel} --output-maf ${sample_id}.maf --vep-path /opt/vep/src/ensembl-vep/  --ncbi-build "GRCh38" --tumor-id ${sample_id} --vcf-tumor-id ${sample_id} --ref-fasta $fasta --cache-version 102

"""



}
