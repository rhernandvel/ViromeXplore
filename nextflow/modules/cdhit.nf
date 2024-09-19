process cdhit {
    tag "CDHIT: clustering of viral sequences"
    label 'cdhit'
    
    publishDir "${params.result_dir}/${params.cdhit_out}", mode: 'copy'
    
    input:
    tuple val (name), path("${params.checkv_out}")

    output:
    tuple val (name), path("${name}_clustered.fasta")

    script:
    """
    cat ${params.checkv_out}/proviruses.fna ${params.checkv_out}/viruses.fna > viruses_combined.fna
    cd-hit-est -i viruses_combined.fna -o ${name}_clustered.fasta -c 0.95 -T ${task.cpus} -M 0 -g 0 -r 1 -d 0
    """
}