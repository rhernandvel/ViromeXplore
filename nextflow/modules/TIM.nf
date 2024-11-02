process  {
    tag "TIM : Taxon Interaction Mapper"
    label 'tim'
    publishDir "${params.result_dir}/${tim_out}", mode: 'copy'

    input:
    tuple val (name), path("${params.flashweave_out}"), file("${params.flashweave_out}/flashweave_result.tsv")
    tuple val (name), file(phylogeny_input_ch)
    tuple val (name), file(taxonomy_input_ch)


    output:
    tuple val (name), path("${params.flashweave_out}/${tim_out}/myTIMrun")

    script:
    """
    python main.py ${phylogeny_input_ch} ${params.flashweave_out}/flashweave_result.tsv 
    python downstream.py
    """

}
