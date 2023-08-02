process virsorter2 {
    tag "Virsorter2: Viral detection"
    label 'virsorter2'
    publishDir "${params.result_dir}", mode: 'copy'

    input:
    tuple val (name), file(contigs_input_ch)
	
    output:
    tuple val (name), path("${params.virsorter_output}"), file("${params.virsorter_output}/final-viral-combined.fa")

    script:
    """    
    virsorter run -w ${params.virsorter_output} -i ${contigs_input_ch} --min-length 1500 -j ${task.cpus} all --viral-gene-enrich-off --keep-original-seq --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae --provirus-off 
    """
}
