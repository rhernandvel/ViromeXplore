process FlashWeave {
    tag "FlashWeave : Obtaining virus host network"
    label 'flashweave'
    publishDir "${params.result_dir}", mode: 'copy'

    input:
    tuple val (name), file(matrix_input_ch)

    output:
    tuple val (name), path("${params.flashweave_out}"), file("${params.flashweave_out}/flashweave_result.tsv")

    script:
    """
    mkdir -p ${params.flashweave_out}
    run_flashweave.jl --input ${matrix_input_ch} -output ${params.flashweave_out}/flashweave_result.tsv
    """

}