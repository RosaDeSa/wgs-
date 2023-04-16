//indexing the genome, if we've already done an index on our genome we can download it from the bucket -> see if else in main
process bwa_index {
    echo true
    label 'index'
    tag 'BWA_INDEX'

    input:
    path(fasta)

    output:
    path('*.txt'), emit: genome_index

    script:
    
    """
    
    mv $fasta genome.fa
    bwa index genome.fa
    mkdir -p $params.outdir/ref/bwaindex
    cp genome.* $params.outdir/ref/bwaindex
    echo bwa_index > done.txt

    """
}