//calculator

process calculator {
     container 'docker://rosadesa/ampliseq:0.4'
    echo true
    label 'calculator'
    tag 'calculator'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("pdf"))   "featureCounts/$filename"
      else if (filename.endsWith("txt"))     "featureCounts/$filename"
      else null
   }

 input:
 tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(base_coverage)


 output:
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_median.txt"), emit: calculator


script:
"""

median="$baseDir/bin/median.awk"
cut -f 3 ${sample_id}.base.coverage.txt | sort -n | awk -f \$median > median_tmp
echo ${sample_id} > sample
paste sample median_tmp > ${sample_id}_median.txt

"""

}