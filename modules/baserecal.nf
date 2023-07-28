//baserecal Generate recalibration table for Base Quality Score Recalibration (BQSR)
process baserecal {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'baserecal'
    tag 'baserecal'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("csv"))   "GATK/BaseRecal/$filename"
      else if (filename.indexOf("table"))     "GATK/BaseRecal/$filename"
      else if (filename.indexOf("dict"))  "GATK/BaseRecal/$filename"
      else null
   }

input:
tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(aligned_bam_bai)
path(fai)
path(known_dbsnp)
path(known_dbsnp_tbi)
path(fasta)
path(know_1000G)
path(know_1000G_tbi)
path(known_mills)
path(known_mills_tbi)
path(genome_dict)

output:
tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.bqsr.grp"), emit: gatk_bqsr

script:
"""

gatk BaseRecalibrator \
  --input ${sample_id}_markdup.bam \
  --reference $fasta \
  --known-sites $known_mills \
  --known-sites $know_1000G \
  --known-sites $known_dbsnp \
  --output ${sample_id}.bqsr.grp

"""

}

//path(gatk_dict)
//path("*.dict"), emit:gatk_dict
//tuple val(sample_id), val(id_patient), val(id_run), emit: gatk_recal_tsv