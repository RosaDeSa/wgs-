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
    tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(sub_sample_1), path(sub_sample_2)

    output:
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("*.{zip,html}"), emit: fastqc_mqc
    path("completed.out"), emit: completed

    script:
    """
  
    fastqc ${sample_id}_split_1.fastq.gz
    
    fastqc ${sample_id}_split_2.fastq.gz
    touch completed.out
    
    """

}