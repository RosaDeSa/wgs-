#!/usr/bin/env nextflow
nextflow.enable.dsl=2


log.info """
         WGS Pipeline (version 3)
         ===================================
         Nextflow DSL2
         Author: Rosa De Santis 
         """
         .stripIndent()

//include section for workflows
include { pcr } from './workflow/pcr.nf'
include { pcr_free } from './workflow/pcr_free.nf'

//channel
if (params.input)                  {input_ch = file(params.input, checkIfExists: true) }                  else { exit 1, 'Input samplesheet not specified!' } 

inputPairReads= Channel.fromPath(input_ch)
           .splitCsv(header:true) 
           .map ({ row-> tuple(row.sample_id, row.id_patient, row.gender, row.id_run, file(row.read_1), file(row.read_2)) })

fasta = Channel.fromPath( params.fasta)
genes_ch = Channel.fromPath( params.genes )
index_ch = Channel.fromPath( params.index )
know_1000G = Channel.fromPath( params.know_1000G)
know_1000G_tbi = Channel.fromPath( params.know_1000G_tbi)
known_mills = Channel.fromPath( params.known_mills)
known_mills_tbi= Channel.fromPath( params.known_mills_tbi)
known_dbsnp = Channel.fromPath( params.known_dbsnp)
known_dbsnp_tbi = Channel.fromPath( params.known_dbsnp_tbi)
bed_ch = Channel.fromPath(params.bed)
exons_ch = Channel.fromPath(params.exons_wgs)

//workflow
workflow {
 if (params.pcrfree) 
   pcr_free(input_ch,fasta,genes_ch,index_ch,know_1000G,know_1000G_tbi,known_mills,known_mills_tbi,known_dbsnp,known_dbsnp_tbi,bed_ch,exons_ch)
 else
    pcr(input_ch,fasta,genes_ch,index_ch,know_1000G,know_1000G_tbi,known_mills,known_mills_tbi,known_dbsnp,known_dbsnp_tbi,bed_ch,exons_ch)
}

workflow.onComplete { 
        log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}