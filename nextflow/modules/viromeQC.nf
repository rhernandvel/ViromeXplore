process viromeQC {
    tag "viromeQC : Contamination detection in Viromes"
    label 'viromeqc'
    publishDir "${params.result_dir}", mode: 'copy'

    input:
    tuple val (name), file(illumina_input_ch)

    output:
    tuple val (name), file("report_file.txt")

    script:
    """    
    viromeQC.py -i ${illumina_input_ch} -o report_file.txt --bowtie2_threads ${task.cpus} --diamond_threads ${task.cpus} -w ${params.samp_type}
    """

}