process markduplicates {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
     echo true
  tag "markduplicates" 
  label "markduplicates"
  publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("bam"))     "bwa/markduplicates/$filename"
      else null
   }


  input:
  tuple val(name), val(id_patient), val(gender),val(id_run), file(aligned_sam) 

  output:
  tuple val(name), val(id_patient), val(gender),val(id_run), path("${sample_id}_markdup.bam"), emit: bam_markdup

  """
  gatk MarkDuplicates -M marked_dup_metrics.txt -I $bam_sort -O ${sample_id}_markdup.bam
  """

}