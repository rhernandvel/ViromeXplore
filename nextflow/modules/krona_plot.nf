process krona {
    tag "krona : Create html krona plots"
    label 'krona'
    publishDir "${params.result_dir}/${params.kaiju_out}", mode: 'copy'

    input:
    tuple val (name), path(dir), file(krona)

    output:
    tuple val (name), path("${name}.html")

    script:
    """    
    ktImportText -o ${name}.html ${krona}
    """
}