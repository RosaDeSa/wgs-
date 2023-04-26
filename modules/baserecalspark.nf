
//Generate recalibration table for Base Quality Score Recalibration (BQSR)
process baserecalspark {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'baserecalspark'
    tag 'baserecalspark'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("table"))     "GATK/BaseRecal_spark/$filename"
      else if (filename.indexOf("csv"))     "GATK/BaseRecal_spark/$filename"
      else null
   }

input:
tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(bam_markdup)
path(fai)
path(genome_dict)
path(known_dbsnp)
path(known_dbsnp_tbi)
path(fasta)
path(know_1000G)
path(know_1000G_tbi)
path(known_mills)
path(known_mills_tbi)


output:
tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.table"), emit: gatk_bqsr_spark


script:
"""

gatk BaseRecalibratorSpark \
  --input ${sample_id}_markdup.bam \
  --reference $fasta \
  --known-sites $known_mills \
  --known-sites $know_1000G \
  --known-sites $known_dbsnp \
  --output ${sample_id}.table \
  --tmp-dir .
"""

}