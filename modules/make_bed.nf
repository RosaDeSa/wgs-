//make bed file
process make_bed {
    echo true
    label 'bed'
    tag 'GTF2BED'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
             if (filename.indexOf("bed") > 0)     "ref/gtf2bed/$filename"          
        else null            
    }

    input:
    path(genes)

    output:
    path('genes.bed'), emit: gene_bed

    script:
    """
    gtf2bed $genes > genes.bed
 

    """
}