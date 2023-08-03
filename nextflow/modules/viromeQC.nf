process viromeQC {
    tag "viromeQC : Contamination detection in Viromes"
    label 'viromeqc'
    publishDir "${params.result_dir}", mode: 'copy'

    input:
    tuple val (name), file(illumina_input_ch)

    output:
    tuple val (name), path("${params.viromeQC_out}"), file("${params.viromeQC_out}/report_file.txt")

    script:
    """    
    mkdir ${params.viromeQC_out}
    viromeQC.py -i ${illumina_input_ch[0]} ${illumina_input_ch[1]} -o ${params.viromeQC_out}/report_file.txt --bowtie2_threads ${task.cpus} --diamond_threads ${task.cpus} -w ${params.samp_type}
    """

}