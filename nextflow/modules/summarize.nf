process summarize {
    tag "summarize: obtain coverage file"
    label 'summarize'
    publishDir "${params.result_dir}/${params.mapping_summary_out}", mode: 'copy'

    input:
    tuple val (name), file("${name}_sorted_output.bam")
	
    output:
    tuple val (name), file("${name}_original.coverage.txt")

    script:
    """    
    jgi_summarize_bam_contig_depths --outputDepth ${name}_original.coverage.txt ${name}_sorted_output.bam
    """
}