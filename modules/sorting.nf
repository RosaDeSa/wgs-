
process sorting {
    echo true
    label 'sorting'
    tag 'samtools'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf("bam") > 0)     "bwa/sorting/$filename"     
            else if (filename.indexOf(".bam.bai") > 0) "bwa/sorting/$filename"
            else if (filename.indexOf(".sam")>0) "bwa/aligned_bam/$filename"
            else null
   	}


    input:
    tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(aligned_sam)


    output:
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.sorted.{sam,bam,bam.bai}"), emit: aligned_bam_bai
  

    script:
    """
    samtools view -S -b ${aligned_sam} | samtools sort -o ${sample_id}.sorted.bam
    samtools index ${sample_id}.sorted.bam 

 
    """

}

