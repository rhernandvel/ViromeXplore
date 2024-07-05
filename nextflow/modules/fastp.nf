process fastp {
    tag "fastp : All-in-one preprocessing for FastQ files"
    label 'fastp'
    publishDir "${params.result_dir}/${params.fastp_out}", mode: 'copy'

    input:
    tuple val(name), file(illumina_input_ch)

    output:
    tuple val(name), file("${name}_1.fastp.fq.gz"), file("${name}_2.fastp.fq.gz"), file("${name}_fastp.html")


    script:
    """
    fastp -i ${illumina_input_ch[0]} -I ${illumina_input_ch[1]} -o ${name}_1.fastp.fq.gz -O ${name}_2.fastp.fq.gz -q ${params.phred_quality} -h ${name}_fastp.html
    """
}
