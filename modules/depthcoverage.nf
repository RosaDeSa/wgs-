//compute coverage depth with GATK
process depthcoverage {
     container 'docker://quay.io/biocontainers/gatk4:4.3.0.0--py36hdfd78af_0'
    echo true
    label 'depthcoverage'
    tag 'depthcoverage'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("vcf"))     "GATK/coverage/$filename"
      else null
   }

   input:

   tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(aligned_bam_bai)
   path(interval_list)
   path(fai)
   path(fasta)
   path(genelist)


   output:

   tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}_base.txt"), emit: coverage_depth
   
   script:

   """
      
       gatk DepthOfCoverage \\
        --input ${aligned_bam_bai} \\
        --intervals ${interval_list} \\
        --output ${sample_id}_base.txt \\
        --reference $fasta \\
        --

   """
}

//adding selection of SNP and indels after haplotyper