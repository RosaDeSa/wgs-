nextflow.enable.dsl=2

//modules
include { bwa_index } from './modules/bwa_index'
include { download_index } from './modules/download_index'
include { make_bed } from './modules/make_bed'
include { fastqc } from './modules/fastqc'
include { trimming } from './modules/trimming'
include {align} from './modules/align'
include {sorting} from './modules/sorting'
/*include {picard} from './modules/picard'
include {featureCounts} from './modules/featurecounts.nf'
include {calculator} from './modules/calculator.nf'
include {coverage_stat} from './modules/coverage_stat.nf'
include {coverage_stat2} from './modules/coverage_stat2.nf'
include {depthcoverage} from './modules/depthcoverage.nf'
include {markduplicates} from './modules/markduplicates.nf'
include {faidx} from './modules/faidx.nf'
include {baserecal} from './modules/baserecal.nf'
include {baserecalspark} from './modules/baserecalspark.nf'
include {applybsrq} from './modules/applybsrq.nf'
include {sorting_bsqr} from './modules/sorting_bsqr.nf'
include {haplotypecall} from './modules/haplotyper.nf'
include {filterindel} from './modules/filterindel.nf' 
include {filtersnps} from './modules/filtersnps.nf'
//include {selectvariants} from './modules/selectvariants.nf'
include {mergevcf} from './modules/mergevcf.nf'
//include {bcftools} from './modules/bcftools.nf'
include {vep} from './modules/vep.nf'
include {qualimap} from './modules/qualimap.nf'
include {cnvantitarget} from './modules/cnvantitarget.nf'
include {cnvreference} from './modules/cnvreference.nf'
include {cnvbatch} from './modules/cnvbatch.nf'
include {multiqc_conf} from './modules/multiqc_conf.nf'
include {multiqc} from './modules/multiqc.nf'
//include {snpeff} from './modules/snpeff.nf'


/*include {vcf_panel} from './modules/vcf_panel.nf'
include {oncokb} from './modules/oncokb.nf'
include {variantcalling} from './modules/variantcalling.nf'
 */



log.info """
         WGS Pipeline (version 1)
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
//genelist = Channel.fromPath(params.genelist)
exons_ch = Channel.fromPath(params.exons_wgs)
//indexed_ch = Channel.fromPath('gs://tigem-gcacchiarelli-01/Reference/Human_hg38_v102/Index_bwa/genome.*')



workflow { 

     //index
       if(!params.downloadIndex) {
     
          bwa_index(fasta)
          indexed_ch=bwa_index.out.genome_index
     } else {
          download_index(index_ch)
          indexed_ch=download_index.out.genome_index.collect()
          //indexed_ch=indexed_ch.collect()
     }
   
     make_bed(genes_ch)

     
     //alignment
     fastqc(inputPairReads)

     //trimming
     trimming(inputPairReads)

     //alignement
     align(indexed_ch.collect(),trimming.out.samples_trimmed)

     //sort

     sorting(align.out.aligned_sam) 

     //picard

     /* picard(sorting.out.aligned_bam_bai,make_bed.out.gene_bed)

     //qualimap(sorting.out.aligned_bam_bai,make_bed.out.gene_bed)

          //featureCounts

     //featureCounts(sorting.out.aligned_bam_bai, genes_ch)
     featureCounts(sorting.out.aligned_bam_bai, exons_ch)

        //calculator

     calculator(featureCounts.out.base_coverage_ex)
     
     //genes_ch,
     //coverage_stat

     coverage_stat(featureCounts.out.base_coverage)
     coverage_stat2(featureCounts.out.base_coverage_ex)
 
     
     markduplicates(sorting.out.aligned_bam_bai)

     //faidx samtools

     faidx(fasta.collect()) 

     //depthcoverage(sorting.out.aligned_bam_bai, fasta.collect(),picard.out.genome_dict, faidx.out.fai)
     
     //BaseRecalibrator
     
     baserecal(markduplicates.out.bam_markdup,faidx.out.fai ,known_dbsnp, known_dbsnp_tbi, fasta.collect(), know_1000G, know_1000G_tbi, known_mills, known_mills_tbi, picard.out.genome_dict)

     //BaseRecalibrationSpark
     
     baserecalspark(markduplicates.out.bam_markdup,picard.out.genome_dict, faidx.out.fai ,known_dbsnp, known_dbsnp_tbi, fasta.collect(), know_1000G, know_1000G_tbi, known_mills, known_mills_tbi)

     applybsrq(markduplicates.out.bam_markdup, baserecalspark.out.gatk_bqsr_spark,fasta.collect(),faidx.out.fai,picard.out.genome_dict)

     sorting_bsqr(applybsrq.out.bam_bqsr_ch)

     //Haplotyper
    haplotypecall(sorting_bsqr.out.indexed_bam_bqsr,
                    baserecalspark.out.gatk_bqsr_spark,
                    applybsrq.out.bam_bqsr_ch,
                    faidx.out.fai.collect(), 
                    picard.out.genome_dict, 
                    known_dbsnp.collect(),
                    known_dbsnp_tbi, 
                    fasta.collect(), 
                    know_1000G.collect(),
                    know_1000G_tbi, 
                    known_mills.collect(), 
                    known_mills_tbi) 

     filterindel(   haplotypecall.out.select_indel,
                    faidx.out.fai.collect(), 
                    picard.out.genome_dict, 
                    known_dbsnp.collect(),
                    known_dbsnp_tbi, 
                    fasta.collect(), 
                    know_1000G.collect(),
                    know_1000G_tbi, 
                    known_mills.collect(), 
                    known_mills_tbi)

     filtersnps(    haplotypecall.out.select_snps,
                    faidx.out.fai.collect(), 
                    picard.out.genome_dict, 
                    known_dbsnp.collect(),
                    known_dbsnp_tbi, 
                    fasta.collect(), 
                    know_1000G.collect(),
                    know_1000G_tbi, 
                    known_mills.collect(), 
                    known_mills_tbi)

     /*selectvariants(filterindel.out.filtered_indels, filtersnps.out.filtered_snps,
                    faidx.out.fai.collect(), 
                    picard.out.genome_dict, 
                    known_dbsnp.collect(),
                    known_dbsnp_tbi, 
                    fasta.collect(), 
                    know_1000G.collect(),
                    know_1000G_tbi, 
                    known_mills.collect(), 
                    known_mills_tbi)*/ //don't run this 
     
    /* mergevcf(filterindel.out.filtered_indels, filtersnps.out.filtered_snps)               
     
     //mergevcf(selectvariants.out.ready_snp,selectvariants.out.ready_indel) don't run this

     vep(mergevcf.out.filtered_vcf,fasta.collect())

     //cnvantitarget(make_bed.out.gene_bed) don't run this 
     //cnvreference(make_bed.out.gene_bed, cnvantitarget.out.antitargets, fasta.collect()) don't run this 
     //cnvbatch(make_bed.out.gene_bed, fasta.collect(),faidx.out.fai.collect(),cnvantitarget.out.antitargets, cnvreference.out.cnn) don't run this 

     //multiqc_conf(fastqc.out.completed, vep.out.completed2) don't run this 

    
     //multiqc(fastqc.out.completed, vep.out.completed2) don't run this 
     
     //multiqc(fastqc.out.completed) don't run this  
    
     //snpeff(haplotypecall.out.gatk_haplotyper,fasta.collect()) don't run this 
     //download_cachedir don't run this 
     //vep(vcf_panel.out.subset_panel,fasta.collect()) don't run this  

     /*
     //vcftomaf
     vcf_panel(bcftools.out.passing_filter) don't run this 

     variantcalling(vcf_panel.out.subset_panel, vcf_panel.out.sample_tmp, vep.out.vep) don't run this  

     oncokb(vep.out.vep) don't run this 
     
  */


     }

