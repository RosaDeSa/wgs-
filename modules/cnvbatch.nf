process cnvbatch {
    container 'docker://etal/cnvkit'
    echo true
    echo true
    label 'cnvbatch'
    tag 'cnvbatch'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf("bed") > 0)     "CNV/$filename"     
            else null
   	}


    input:
    path(aligned_bam_bai)
    path(fasta)
    path(fai)
    path(gene_bed)
    path(cnn)


    output:
    path("*.cnn"), emit: cnn
   

    """

            cnvkit.py \\
            batch \\
            $aligned_bam_bai \\
            $fasta \\
            $cnn \\
            $gene_bed \\
           

    """
}