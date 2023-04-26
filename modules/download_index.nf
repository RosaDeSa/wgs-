//index the genome if we have not indexed before

process download_index {
    echo true
    label 'd_index'
    tag 'BWA_INDEX'

    input:
    path(index)

    output:
    path('*txt'), emit: genome_index

    script:
    """
    cp Index_*/* $params.outdir
    echo bwa_index > done.txt
    """
}

    // mkdir -p $params.outdir/ref/index
    //cp Index_*/* $params.outdir/ref/index/
   // samtools faidx $params.outdir/ref/index/genome.fa 
    //echo bwa_index > done.txt 
    