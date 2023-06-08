process markduplicates {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
     echo true
  tag "markduplicates" 
  label "markduplicates"
  publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("bam"))     "bwa/markduplicates/$filename"
         else if (filename.endsWith("txt"))     "bwa/markduplicates/$filename"
      else null
   }


  input:
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path(aligned_bam_bai)

  output:
  tuple val(sample_id), val(id_patient), val(gender),val(id_run), path("${sample_id}_markdup.bam"), emit: bam_markdup
  tuple val(sample_id), val(id_patient), val(gender),val(id_run), path("${sample_id}_marked_dup_metrics.txt"), emit: markdup_metrics

  """
  gatk MarkDuplicates -M ${sample_id}_marked_dup_metrics.txt -I ${sample_id}.sorted.bam  -O ${sample_id}_markdup.bam
  """

}