process bowtie2 {
    tag "bowtie2 : Read mapping against viral contigs"
    label 'bowtie2'
    publishDir "${params.result_dir}", mode: 'copy'

    input:
    tuple val (name), file(contigs_input_ch)
    tuple val(name), file(illumina_input_ch)

    output:
    tuple val (name), path("${params.bowtie_out}"), path("${params.bowtie_out}/${params.bowtie_index_out}/${name}*.bt2"), file("${params.bowtie_out}/${name}.sam")

    script:
    """    
    mkdir -p ${params.bowtie_out}
    mkdir -p ${params.bowtie_out}/${params.bowtie_index_out}
    bowtie2-build --threads ${task.cpus} ${contigs_input_ch}  ${params.bowtie_out}/${params.bowtie_index_out}/${name}
    bowtie2 -p ${task.cpus} -x ${params.bowtie_out}/${params.bowtie_index_out}/${name} -1 ${illumina_input_ch[0]} -2 ${illumina_input_ch[1]} -S ${params.bowtie_out}/${name}.sam
    """

}