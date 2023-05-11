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
      path(completed)
       //path(completed2)
      //path(config)


      output:
          path 'multiqc.html', emit: multiqc_report
          path '*_data'
         


      script:

        """
       multiqc $params.outdir -n multiqc.html . --cl-config "log_filesize_limit: 2000000000" 
      
        """
}

       //multiqc $params.outdir -n multiqc.html  --config $params.outdir/Coverage_multiqc_config.yaml --cl-config "log_filesize_limit: 2000000000" 
