process vsearch {
    tag "VSEARCH: Query genomes vs Virus-Host DB"
    label 'vsearch'
    
    publishDir "${params.result_dir}/${params.vsearch_out}", mode: 'copy'
    
    input:
    tuple val (name), path("${params.geNomad_out}")
    path(virus_host_database)

    output:
    tuple val (name), path("${name}_vsearch_results.tsv")

    script:
    """
    vsearch --usearch_global ${params.geNomad_out}/${name}_summary/${name}_virus.fna --db ${virus_host_database} --id 0.99 --blast6out ${name}_vsearch_results.tsv
    """
}