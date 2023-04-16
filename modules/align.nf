// alignment with bwa

process align {
    echo true
    label 'align'
    tag 'BWA'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf("sam") > 0)     "bwa/$filename"     
            else null
   	}


    input:
    path(genome_index)
    tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(samples_trimmed)


    output:
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.sam"), emit: aligned_sam



    script:
    """

    bwa mem -K 100000000 -R "@RG\\tID:${sample_id}\\tPU:${id_run}\\tSM:${sample_id}\\tLB:${sample_id}\\tPL:atoplex" -t 24 -M $params.outdir/ref/index/genome.fa \
    ${samples_trimmed} > ${sample_id}.sam

    """

}