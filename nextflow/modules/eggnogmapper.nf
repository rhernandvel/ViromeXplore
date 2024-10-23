process eggnog_mapper {
    tag "Eggnog-mapper: fast functional annotation"
    label 'eggnog_mapper'
    
    publishDir "${params.result_dir}/${params.eggnog_mapper_out}", mode: 'copy'
    
    input:
    tuple val (name), path("${params.geNomad_out}")
    path(eggnog_data)

    output:
    tuple val (name), path("${name}_eggnog.out.emapper.hits"), path("${name}_eggnog.out.emapper.seed_orthologs"), path("${name}_eggnog.out.emapper.annotations")

    script:
    """
    emapper.py -i ${params.geNomad_out}/${name}_summary/${name}_virus_proteins.faa -o ${name}_eggnog.out --data_dir ${eggnog_data} --cpu ${task.cpus}
    """
}
