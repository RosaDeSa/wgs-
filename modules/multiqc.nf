//run multiqc
process multiqc {
    container 'docker://rosadesa/ampliseq:2.2'
    echo true
    label 'multiqc'
    tag "multiqc"
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("html"))        "multiqc/$filename"
      else if (filename.indexOf("data"))     "multiqc/$filename"
      else null
   }

      input:
      //file ("fastqc/*") 
      //file ('GATK/*') 
      //file ('Haplotyper/*') 
      //file ('picard/*') 
      //file ('VEP/*') 
       //path files_path
     path(completed)
     path(completed2)
      //path(config)


  
     output:
          path 'multiqc.html', emit: multiqc_report
          path '*_data'
         

      script:

      """
     multiqc $params.outdir -n multiqc.html  --config $params.outdir/Coverage_multiqc_config.yaml --cl-config "log_filesize_limit: 2000000000"       
      """
}

