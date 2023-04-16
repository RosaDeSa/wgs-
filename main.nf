nextflow.enable.dsl=2

//modules
include { bwa_index } from './modules/bwa_index'
include { download_index } from './modules/download_index'
include { make_bed } from './modules/make_bed'
include { fastqc } from './modules/fastqc'
include { trimming } from './modules/trimming'
include {align} from './modules/align'
/*include {sorting} from './modules/sorting'
include {picard} from './modules/picard'
include {featureCounts} from './modules/featureCounts'
include {calculator} from './modules/calculator.nf'
include {coverage_stat} from './modules/coverage_stat.nf'
include {faidx} from './modules/faidx.nf'
include {download_reference} from './modules/download_reference.nf'
include {baserecal} from './modules/baserecal.nf'
include {baserecalspark} from './modules/baserecal_spark.nf'
include {haplotypecall} from './modules/haplotyper.nf'
include {bcftools} from './modules/bcftools.nf'
include {vcf_panel} from './modules/vcf_panel.nf'
include {vep} from './modules/vep.nf'
include {oncokb} from './modules/oncokb.nf'
include {variantcalling} from './modules/variantcalling.nf'
include {multiqc_conf} from './modules/multiqc_conf.nf'
include {multiqc} from './modules/multiqc.nf' */


/*
 * Create a channel for input read files
 */
// TODO: adjust input channel read to read csv file

log.info """
         Ampliseq Pipeline (version 1)
         ===================================
         Nextflow DSL2
         Author: Rosa De Santis 
         """
         .stripIndent()
     
// check

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



workflow { 

     //index
       if(!params.downloadIndex) {
     
          bwa_index(fasta)
          indexed_ch=bwa_index.out.genome_index
     } else {
          download_index(index_ch)
          indexed_ch=download_index.out.genome_index.collect()
     }
   
     make_bed(genes_ch)

     
     //alignment
     fastqc(inputPairReads)

     //trimming
     trimming(inputPairReads)

     //alignement
     align(indexed_ch.collect(),trimming.out.samples_trimmed)

     //sort

     /*sorting(align.out.aligned_sam) 

     //picard

     picard(sorting.out.aligned_bam_bai,make_bed.out.gene_bed)

     //featureCounts

     featureCounts(sorting.out.aligned_bam_bai)

     //calculator

     calculator(featureCounts.out.base_coverage)

     //coverage_stat

     coverage_stat(featureCounts.out.base_coverage)

     //faidx samtools

     faidx(fasta.collect()) 

     //BaseRecalibrator

     //genomedict(fasta)
     baserecal(sorting.out.aligned_bam_bai,faidx.out.fai ,known_dbsnp, known_dbsnp_tbi, fasta.collect(), know_1000G, know_1000G_tbi, known_mills, known_mills_tbi, picard.out.genome_dict)

     //BaseRecalibrationSpark
     
     baserecalspark(sorting.out.aligned_bam_bai,picard.out.genome_dict, faidx.out.fai ,known_dbsnp, known_dbsnp_tbi, fasta.collect(), know_1000G, know_1000G_tbi, known_mills, known_mills_tbi)

     
     //Haplotyper
    /* haplotypecall(sorting.out.aligned_bam_bai,
                    baserecalspark.out.gatk_bqsr_spark.collect(), 
                    faidx.out.fai.collect(), 
                    picard.out.genome_dict, 
                    known_dbsnp.collect(),
                    known_dbsnp_tbi, 
                    fasta.collect(), 
                    know_1000G.collect(),
                    know_1000G_tbi, 
                    known_mills.collect(), 
                    known_mills_tbi) */

     /*bcftools(filtercalls.out.filtered_vcf)
     //vcftomaf
     vcf_panel(bcftools.out.passing_filter)

     //vep
     //download_cachedir()


     vep(vcf_panel.out.subset_panel,fasta.collect())

     variantcalling(vcf_panel.out.subset_panel, vcf_panel.out.sample_tmp, vep.out.vep)

     oncokb(vep.out.vep)
     
     multiqc_conf(variantcalling.out.completed2,fastqc.out.completed)

     multiqc(variantcalling.out.completed2,fastqc.out.completed) */


     }

