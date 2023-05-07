//qualimap

process qualimap {
     container 'docker://pegi3s/qualimap'
    echo true
    label 'qualimap'
    tag 'qualimap'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("pdf"))   "qualimap/$filename"
      else if (filename.endsWith("html"))     "qualimap/$filename"
      else null
   
   	}

    
 input:
 tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(aligned_bam_bai)
 path(gene_bed)

 output:
 tuple val(sample_id), val(id_patient), val(gender), val(id_run),path("${sample_id}.html"), emit: qualimap
 
     
script:

"""
qualimap bamqc -bam ${sample_id}.sorted.bam -c --skip-duplicated --java-mem-size=4G

"""

}


