//index the genome if we have not indexed before

process download_index {
    echo true
    label 'd_index'
    tag 'BWA_INDEX'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("fa"))     "ref/index/$filename"
      else null
   }

    input:
    path(index)

    output:
    path("genome.fa")
    path("genome.fa.sa")
    path('*txt'), emit: genome_index

    script:
    """

    echo bwa_index > done.txt
    
    """
}

    // mkdir -p $params.outdir/ref/index
    //cp Index_*/* $params.outdir/ref/index/
   // samtools faidx $params.outdir/ref/index/genome.fa 
    //echo bwa_index > done.txt 
    