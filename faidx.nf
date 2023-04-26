//create fai fasta

  process faidx {
    //container 'docker://rosadesa/ampliseq:0.5'
    echo true
    label 'faidx'
    tag 'faidx'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("fai"))   "samtools/faidx/$filename"
      else null
   }

input:
path(fasta)

output:
path ("*.fai"), emit: fai

script:
"""
samtools faidx $fasta 
"""

}