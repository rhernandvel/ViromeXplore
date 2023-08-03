process kaiju {
    tag "kaiju : Read classification using virus database"
    label 'kaiju'
    publishDir "${params.result_dir}/${params.kaiju_out}", mode: 'copy'

    input:
    tuple val (name), file(illumina_input_ch)
    path(database)

    output:
    tuple val (name), path("${name}.out"), path("${name}.out.krona")
    //file("${params.viromeQC_out}/report_file.txt")

    script:
    """    
    kaiju -z ${task.cpus} -t ${database}/nodes.dmp -f ${database}/kaiju_db_viruses.fmi -v -i ${illumina_input_ch[0]} -j ${illumina_input_ch[0]} -o ${name}.out
    kaiju2krona -t ${database}/nodes.dmp -n ${database}/names.dmp -i ${name}.out -o ${name}.out.krona
    """
}
