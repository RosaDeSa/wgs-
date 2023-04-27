//index the genome if we have not indexed before

process download_index {
    echo true
    label 'd_index'
    tag 'BWA_INDEX'


    input:
    path(index)

    output:
    path("genome.fa")
    path("genome.fa.sa")
    path('*txt'), emit: genome_index

    script:
    """
    cd /home/tigem/r.desantis/wgs
    mkdir -p $params.outdir/ref/index
    cp Index_*/* $params.outdir/ref/index/
    samtools faidx $params.outdir/ref/index/genome.fa 
    echo bwa_index > done.txt 
    
    """
}

    // mkdir -p $params.outdir/ref/index
    //cp Index_*/* $params.outdir/ref/index/
   // samtools faidx $params.outdir/ref/index/genome.fa 
    //echo bwa_index > done.txt 
    