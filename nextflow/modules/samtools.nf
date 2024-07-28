process samtools {
    tag "samtools: Convert and sort file "
    label 'samtools'
    publishDir "${params.result_dir}/${params.samtools_out}", mode: 'copy'

    input:
    //tuple val (name), path("${params.bowtie_out}"), path("${params.bowtie_out}/${params.bowtie_index_out}/${name}*.bt2"), file("${params.bowtie_out}/${name}.sam")
    tuple val (name), path("${params.bowtie_out}"), file("${params.bowtie_out}/${name}.sam")
	
    output:
    tuple val (name), file("${name}_sorted_output.bam")

    script:
    """    
    samtools view --threads ${task.cpus} -bS ${params.bowtie_out}/${name}.sam | samtools sort --threads ${task.cpus} -o ${name}_sorted_output.bam -
    """
}