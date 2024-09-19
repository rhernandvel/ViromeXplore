process fastani_virhostdb {
    tag "FastANI: Query genomes vs Virus-Host DB"
    label 'fastani_virhostdb'
    
    publishDir "${params.result_dir}/${params.fastani_virhostdb_out}", mode: 'copy'
    
    input:
    tuple val (name), file(viral_contigs_ch)
    file(virus_host_database)

    output:
    tuple val (name), path("${name}_fastani.out")

    script:
    """
    fastANI --ql ${viral_contigs_ch} --rl ${virus_host_database} -o ${name}_fastani.out -t 12 --fragLen 1000 
    """
}
