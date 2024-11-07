process checkv {
    tag "CheckV: Quality of viral genomes"
    label 'checkv'
    
    publishDir "${params.result_dir}", mode: 'copy'
    
    input:
    tuple val (name), file(dir), file(fasta)
    file(database)

    output:
    tuple val (name), path("${params.checkv_out}")

    script:
    """
    checkv end_to_end ${fasta} ${params.checkv_out} -t ${task.cpus} -d ${database}
    """
}
