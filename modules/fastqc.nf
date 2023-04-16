// fastqc 

process fastqc {
    echo true
    label 'fastqc'
    tag 'FASTQC'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("zip") > 0)     "fastqc/zips/$filename"
        else if (filename.indexOf("html") > 0)    "fastqc/$filename"            
        else null            
    }

    input:
    tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(read_1),path(read_2)

    output:
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("*.{zip,html}"), emit: fastqc_mqc
    path("completed.out"), emit: completed

    script:
    """
    ln -s ${read_1} ${sample_id}_1.fastq.gz
    fastqc ${sample_id}_1.fastq.gz
    ln -s ${read_2} ${sample_id}_2.fastq.gz
    fastqc ${sample_id}_2.fastq.gz
    touch completed.out
    
    """

}