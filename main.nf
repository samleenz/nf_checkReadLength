// a nextflow pipeline for checking the read-length of fastq files
// Uses seqkit to
// 1. sample 5% of the reads
// 2. calculate the average read length

// Written by Sam Lee
// Davis Lab


// include the appropriate process

process RUN_READ_LENGTH {
    cpus 1
    memory "12.G"
    time {"10.m" * task.attempt}
    container "quay.io/biocontainers/seqkit:2.5.1--h9ee0642_0"
    tag "$sample"


    input:
    tuple val(sample), path(read) // 


    output:
    path("${sample}_read_length.txt")


    script:
    """
    seqkit sample -p 0.05 $read | \
    seqkit fx2tab -nl  |\
    awk '{ sum += \$NF } END { if (NR > 0) print sum / NR }' \
    > read_length.txt

    echo ${sample} \$(cat read_length.txt) > "${sample}_read_length.txt"
    """
}

process RUN_SAVE_FILE {
    cpus 1
    memory "2.G"
    time "2.m"
    publishDir "./", mode: "copy"

    input:
        path(files)

    output:
        path("read_lengths.txt")


    script:
    """
    cat $files > read_lengths.txt
    """

}



workflow {
    reads_ch = Channel.fromPath(params.samplesheet, checkIfExists: true)
        .splitCsv(header: true)
        .map(row -> tuple(row.sample, row.read1))

    read_lengths_ch = RUN_READ_LENGTH(reads_ch)
    
    RUN_SAVE_FILE(read_lengths_ch.collect())


}