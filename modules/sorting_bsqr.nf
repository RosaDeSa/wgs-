
process sorting_bsqr {
    echo true
    label 'sorting_bsqr'
    tag 'sorting_bsqr'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf("bam") > 0)     "bwa/sorting_bsqr/$filename"     
            else if (filename.indexOf(".bam.bai") > 0) "bwa/sorting_bsqr/$filename"
            else null
   	}


    input:
    tuple val(sample_id),  val(id_patient), val(gender),val(id_run), path(bam_bqsr_ch)


    output:
    tuple val(sample_id),  val(id_patient), val(gender),val(id_run), path("${sample_id}.bqsr.bam.bai"), emit: indexed_bam_bqsr
  

    script:
    """

    samtools index ${sample_id}_bqsr.bam

 
    """

}

