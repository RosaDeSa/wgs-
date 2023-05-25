//compute percentage of coverage 
process coverage_stat {
     container 'docker://rosadesa/ampliseq:0.4'
    echo true
    label 'coverage_stat'
    tag 'coverage_stat'
    publishDir "$params.outdir" , mode: 'copy',
     saveAs: {filename ->
           if (filename.endsWith("pdf"))   "featureCounts/$filename"
      else if (filename.endsWith("txt"))     "featureCounts/$filename"
      else null
   }


 input:
 tuple val(sample_id), val(id_patient), val(gender),val(id_run),path(base_coverage)


 output:
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.base.coverage.stat.txt"), emit: coverage_metrics
 tuple val(sample_id), val(id_patient), val(gender), val(id_run), path("${sample_id}.base.coverage.perc.txt"), emit: coverage_percent
 
 script:
 
 """
 
        echo " ... computing the uniformity of coverage stats for ${sample_id}"

        occurence=\$(cat ${sample_id}.base.coverage.txt | wc -l)
        grt_zero=(\$(awk '\$3 > 0' ${sample_id}.base.coverage.txt | wc -l ))
        grt_10=(\$(awk '\$3 >= 10' ${sample_id}.base.coverage.txt | wc -l ))
        grt_20=(\$(awk '\$3 >= 20' ${sample_id}.base.coverage.txt | wc -l ))
        grt_30=(\$(awk '\$3 >= 30' ${sample_id}.base.coverage.txt | wc -l ))
        grt_50=(\$(awk '\$3 >= 50' ${sample_id}.base.coverage.txt | wc -l ))
        grt_100=(\$(awk '\$3 >= 100' ${sample_id}.base.coverage.txt | wc -l ))
        grt_150=(\$(awk '\$3 >= 150' ${sample_id}.base.coverage.txt | wc -l ))
        grt_300=(\$(awk '\$3 >= 300' ${sample_id}.base.coverage.txt | wc -l ))



echo -e "sample\t=tot\t>=1x\t>=10x\t>=20x\t>=30x\t>=50x\t>=100x\t>=150x\t>=300" > ${sample_id}.base.coverage.stat.txt
echo -e "${sample_id}\t\$occurence\t\$grt_zero\t\$grt_10\t\$grt_20\t\$grt_30\t\$grt_50\t\$grt_100\t\$grt_150\t\$grt_300" >> ${sample_id}.base.coverage.stat.txt

tail -1 ${sample_id}.base.coverage.stat.txt > tmp.txt

awk '{print \$1"\t"100*\$3/\$2"\t"100*\$4/\$2"\t"100*\$5/\$2"\t"100*\$6/\$2"\t"100*\$7/\$2"\t"100*\$8/\$2"\t"100*\$9/\$2"\t"100*\$10/\$2}' tmp.txt  > ${sample_id}.base.coverage.perc.txt
sed -i '1iSample\tcov1x\tcov10x\tcov20x\tcov30x\tcov50x\tcov100x\tcov150x\tcov300x' ${sample_id}.base.coverage.perc.txt

 """

}