//create configuration file for multiqc, remembre to change the work directory to run the pipeline in enviroments
process multiqc_conf {
    container 'docker://rosadesa/ampliseq:2.2'
    echo true
    label 'multiqc_conf'
    tag "multiqc_conf"
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
        if (filename.indexOf("html"))        "multiqc/$filename"
      else if (filename.indexOf("data"))     "multiqc/$filename"
      else null
   }

      input:
      //completed2 just to run multiqc in the end of the other process
    
      path(completed)
      path(completed2)

  

      //output:
      //file("Coverage_multiqc_config.yaml"), emit: config


        
      script:

        """
       
       Rscript --vanilla $baseDir/bin/config_multiqc.R
      
       
        """
}

 //multiqc -n multiqc_report.html --config Coverage_multiqc_config.yaml
 
 
 //Rscript ./config_multiqc.R
     // multiqc  -n multiqc_report.html --config Coverage_multiqc_config.yaml

//config_multiqc.R
       //multiqc -n multiqc_report.html --config Coverage_multiqc_config.yaml
        

     //multiqc $params.outdir -n multiqc_report.html --cl-config "log_filesize_limit: 2000000000" 