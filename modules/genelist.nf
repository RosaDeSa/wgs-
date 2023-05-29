//picard

process genelist {
     container 'docker://rosadesa/ampliseq:0.3'
    echo true
    label 'genelist'
    tag 'genelist'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("vcf"))   "picard/$filename"
      else null
   
   	}
    
 input:
 path(genelist)
 path(genome_dict)
 path(fasta)


 output:

 path("genelist_sorted.vcf"), emit: genelist

     
script:

"""
java -jar picard.jar SortVcf --INPUT ${genelist} --OUTPUT genelist_sorted.vcf --SEQUENCE_DICTIONARY ${genome_dict}
"""

}


