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
    qiime tools import --type 'FeatureData[Sequence]' --input-path ${fasta} --output-path ${name}_sequences.qza
    qiime viromics checkv-analysis --i-sequences ${name}_sequences.qza --i-database ${database} --p-num-threads ${task.cpus} --output-dir ${params.checkv_out} --verbose
    """
}
