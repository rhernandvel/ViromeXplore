process megahit {
    tag "megahit : All-in-one preprocessing for FastQ files"
    label 'megahit'
    publishDir "${params.result_dir}", mode: 'copy'

    input:
    tuple val(name), file("${name}_1.fastp.fq.gz"), file("${name}_2.fastp.fq.gz")

    output:
    tuple val(name), path("${params.megahit_out}"), file("${params.megahit_out}/final.contigs.fa")


    script:
    """
    megahit -1 ${name}_1.fastp.fq.gz -2 ${name}_2.fastp.fq.gz -o ${params.megahit_out} --k-list ${params.kmers_assembly} -t ${task.cpus}
    """
}
