process cnvantitarget {
    container 'docker://etal/cnvkit'
    echo true
    echo true
    label 'cnvantitarget'
    tag 'cnvantitarget'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf("bed") > 0)     "CNV/$filename"     
            else null
   	}


    input:
    path(gene_bed)

    output:
    path("*.bed"), emit: antitargets
   

    """
    cnvkit.py \\
        antitarget \\
        $gene_bed \\
        --output CNV.antitarget.bed \\
        $args

    """
}




