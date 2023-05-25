
process featureCounts {
     container 'docker://rosadesa/ampliseq:0.4'
    echo true
    label 'featureCounts'
    tag 'featureCounts'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("pdf"))   "featureCounts/$filename"
      else if (filename.endsWith("txt"))     "featureCounts/$filename"
      else null
   
   	}


        
 input:
 tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(aligned_bam_bai)
 path(genes_ch)



 output:
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_count.txt"), emit: txt_featurecount
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.base.coverage.txt"), emit: base_coverage


 script:
 
"""

featureCounts -O -a ${genes_ch} -g ID -p ${sample_id}.sorted.bam -o ${sample_id}_count.txt
samtools depth -q 20 -aa  ${sample_id}.sorted.bam  > ${sample_id}.base.coverage.txt


"""
 
}
