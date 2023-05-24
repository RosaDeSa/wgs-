process CNVreference {
    container 'docker://etal/cnvkit'
    echo true
    echo true
    label 'CNVreference'
    tag 'CNVreference'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf("bed") > 0)     "CNV/$filename"     
            else null
   	}


    input:
    path(gene_bed)
    path(fasta)
    path(antitargets)

    output:
    path("*.cnn"), emit: cnn
   

    """
    cnvkit.py \\
        reference \\
        --fasta $fasta \\
        --targets $gene_bed \\
        --antitargets $antitargets \\
        --output CNV.reference.cnn \\
    

    """
}

   