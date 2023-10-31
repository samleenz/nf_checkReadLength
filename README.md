# Check Read legnth of rnaseq files

V0.1.0

## Usage

```bash
nextflow run samleenz/nf_checkReadLength --samplesheet "<samplesheet.csv>"   
```

Example `samplesheet.csv`

```
sample, fastq1, fastq2
sample1, /path/to/sample1_R1.fastq.gz, /path/to/sample1_R2.fastq.gz
sample2, /path/to/sample2_R1.fastq.gz, /path/to/sample2_R2.fastq.gz
```


For each sample in the samplesheet, the script will check the read length of 5% of the reads in the fastq file and save the average of each these in a file called `read_lengths.txt` in the output directory.