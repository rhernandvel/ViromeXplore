process geNomad {
    tag "geNomad: Viral identification and taxonomy"
    label 'genomad'

    publishDir "${params.result_dir}", mode: 'copy'
    
    input:
    tuple val (name), file(viral_contigs_ch)
    path(genomad_db)

    output:
    tuple val (name), path("${params.geNomad_out}")

    script:
    """
    genomad end-to-end --threads 8 --cleanup --verbose ${viral_contigs_ch} ${params.geNomad_out} ${genomad_db}
    """
}
