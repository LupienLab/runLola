#!/bin/bash
#SBATCH -p himem
#SBATCH --mem=60G
#SBATCH -t 12:00:00
#SBATCH -J Remap2022
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -c 1

echo "running LOLA"


module load bedtools/2.23.0
module load R/3.4.1

loladb="hg38_remapdb_2022"

for db in $loladb ;
do  
    dbname="remap2022"
    queryname=sample1
    opname=$queryname"_bg_catpeaks_"$dbname
    echo "----------------------------------------------------------------"
    echo "File being analysed is " $opname
    echo "----------------------------------------------------------------"
    mkdir -p results/$opname


    Rscript lola.R \
            sample1.bed \
            consensusbackground.bed \
            $db \
            results/$opname
done
