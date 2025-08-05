#!/bin/bash
#$ -P bioinfo-ms                   
#$ -N lr_kallisto 
#$ -cwd  
#$ -pe omp 24                                
#$ -o lr_kallisto_test.out  
#$ -e lr_kallisto_test.err  

# Reference files
INDEX="./refs/human_k-63.idx"
T2G="./refs/human.t2g"
TRANSCRIPTS="transcripts.txt"
EC_MATRIX="matrix.ec"
GTF="./refs/gencode.v48.annotation.gtf"
FLENS="flens.txt"

mkdir lr_kallisto

for i in 02 03 04 09 10 11 12; do
    SAMPLE="bc$i"
    FASTQ="./results/fastq/${SAMPLE}.fastq.gz"
    echo "Processing $SAMPLE..."

    # Output directories
    PARENT_DIR="lr_kallisto/${SAMPLE}"

    mkdir -p "$PARENT_DIR"

    # kallisto bus
    kallisto bus -t 16 --verbose --long --threshold 0.8 -x bulk -i "$INDEX" -o "$PARENT_DIR" "$FASTQ"

    # bustools sort
    bustools sort "$PARENT_DIR/output.bus" -o "$PARENT_DIR/sorted.bus"

    # bustools count
    bustools count "$PARENT_DIR/sorted.bus" -t "$PARENT_DIR/$TRANSCRIPTS" -e "$PARENT_DIR/$EC_MATRIX" -o "$PARENT_DIR/${SAMPLE}" --cm -m -g "$T2G"

    # kallisto quant-tcc
    kallisto quant-tcc -t 24 --long -P PacBio -f "$PARENT_DIR/$FLENS" "${PARENT_DIR}/${SAMPLE}.mtx" \
        -i "$INDEX" -e "$PARENT_DIR/${SAMPLE}.ec.txt" --matrix-to-directories \
        -G "$GTF" -o "$PARENT_DIR"

    echo "Finished $SAMPLE"
done