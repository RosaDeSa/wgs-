//trimming with soapnuke
process trimming {
    echo true
    label 'SOAPnuke'
    tag 'SOAPnuke'
    container 'docker://giusmar/gc-covid19:0.1.0'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
      if (filename.indexOf(".html") > 0) "fastqc/TrimQC/$filename"
      else if (filename.indexOf(".zip") > 0) "fastqc/TrimQC/zip/$filename"
      else if (filename.indexOf(".fastq.gz") > 0) "SOAPnuke/$filename"
      else if (filename.indexOf("txt") > 0)     "SOAPnuke/txt/$filename"
      else null
        }
 
    input:
      tuple val(sample_id), val(id_patient), val(gender),val(id_run), path(read_1), path(read_2)

    output:
    tuple val(sample_id),val(id_patient),val(gender), val(id_run), path("${sample_id}_paired_R*.trimmed.fastq.gz") ,emit: samples_trimmed
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), file('*.{zip,html,txt}'), emit: qc_results
    tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("Basic_Statistics_of_Sequencing_Quality.txt"), emit: basic
 

    script:
    """
    ln -s ${read_1} ${sample_id}_1.fastq.gz
    ln -s ${read_2} ${sample_id}_2.fastq.gz

    SOAPnuke filter \
        --lowQual $params.soapnuke_lowQual \
        --qualRate $params.soapnuke_qualRate \
        --nRate $params.soapnuke_nRate \
        --mean $params.soapnuke_mean \
        --adapter1 $params.soapnuke_adapter1 \
        --adapter2 $params.soapnuke_adapter2 \
        --fq1 ${sub_sample_1} \
        --fq2 ${sub_sample_2} \
        --cleanFq1 ${sample_id}"_paired_R1.trimmed.fastq.gz" \
        --cleanFq2 ${sample_id}"_paired_R2.trimmed.fastq.gz" \
        --outDir .

         fastqc -q  ${sample_id}_paired_R1.trimmed.fastq.gz
         fastqc -q  ${sample_id}_paired_R2.trimmed.fastq.gz
    """

}