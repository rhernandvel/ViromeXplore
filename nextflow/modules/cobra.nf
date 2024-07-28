process cobra {
    tag "cobra: Contig Overlap Based Re-Assembly "
    label 'cobra'
    publishDir "${params.result_dir}/${params.cobra_out}", mode: 'copy'

    input:
    tuple val (name), file("${name}_original.coverage.txt")
    tuple val (name), file(viral_contigs_ch)
    tuple val (name), file(contigs_input_ch)
    tuple val (name), file("${name}_sorted_output.bam")

    output:
    tuple val (name), path("${name}")

    script:
    """    
    coverage.transfer.py -i ${name}_original.coverage.txt -o ${name}_coverage.txt
    cobra-meta -q ${viral_contigs_ch} -f ${contigs_input_ch} -a ${params.cobra_assembly} -mink ${params.min_kmer} -maxk ${params.max_kmer} -m ${name}_sorted_output.bam -c ${name}_coverage.txt -o ${name} -t ${task.cpus}
    """
}