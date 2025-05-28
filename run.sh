#!/bin/bash
#BATCH -p himem
#SBATCH --mem=30G
#SBATCH -t 48:00:00
#SBATCH -J Remap2020_TFs
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -c 1

#-------------------------------------------------------------------------------------------------------------------------------------
-
# Script adapted from Aditi's script 13_runLOLA_Run_20190402 designed to assess enrichment of TF (ChIP-seq - Remap) on TEs of interest
# Background of analysis: all TEs overlapping the dataset of interest (e.g. H3K27ac PCa)
# Run this script on h4h - no LOLA package on mordor!!!
#-------------------------------------------------------------------------------------------------------------------------------------
-

module load bedtools/2.23.0
module load R/3.6.1


#----------------------------------------------------------------
## LOLA Databases
#----------------------------------------------------------------

loladb="hg38_remap2022/"

#----------------------------------------------------------------
## Run LOLA on each repeat subfam
#----------------------------------------------------------------

# input the path of each TE subfamily of interest - on h4h
queryfiles="/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1138_MIR1_Amn.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1141_MIR.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1140_MIRb.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1142_MIRc.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1161_MLT1F1.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1163_MLT1F2.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1164_MLT1F2-int.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1165_MLT1F.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1169_MLT1G3.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1202_MLT2C2.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1373_Tigger12c.bed.sorted
/cluster/projects/lupiengroup/People/ggrillo/data/repeat.subfam/hg38_only_TEs/1375_Tigger14a.bed.sorted"


for db in $loladb ;
do
    dbname=$(echo $db | awk -F"/" '{print $(NF-2)}')
    echo $dbname
    for query in $queryfiles ;
    do
        queryname=$(echo $query | awk -F"/" '{print $NF}' | sed -e 's/.bed.sorted//g')
        opname=$queryname"_"$dbname
        echo "----------------------------------------------------------------"
        echo "File being analysed is " $opname
        echo "----------------------------------------------------------------"
        mkdir -p $opname

       intersectBed -a $query -b consensus.bed -u > $opname/querytmp.bed

       Rscript lola.R \
       $opname/querytmp.bed \
       consensus.bed \
       $db \
       $opname
    done
done

