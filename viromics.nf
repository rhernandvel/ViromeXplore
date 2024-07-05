#! /usr/bin/env nextflow
nextflow.enable.dsl=2
params.help = false

def helpMessage() {
  log.info """
                   VIRTOOLS - N F 
        ===================================
        USAGE:
        Run the workflow as follows:

        nextflow run viromics.nf --pipeline "valid_pipeline_name" --fasta/reads 'file.fasta/file(s).fq' 

        MANDATORY ARGUMENTS:
         --pipeline                     Valid pipeline name                                   [qc_classify/viral_assembly/find_viruses/host_prediction/annotate]
         
         For the qc_classify and viral_assembly pipelines:
         --reads                  Reads FASTQ format                                                             ['basename_{1,2}.fastq']
         
         For the find_viruses and annotate pipelines 
         --fasta                        Contigs file in FASTA format                                             ['file.fasta']

         For the host_prediction pipeline: 
         --phylogeny                    Phylogenetic tree for the viruses being analyzed (NEWIK format)          [virus_phylogeny.nwk]
         --taxonomy                     Lineage of host in NCBI terms (TAB DELIMITED file with ID and lineage)   [taxonomy_file.tsv]
         --matrix                       Matrix containing the abundances of viruses and hosts  (TAB DELIMITED)   [matrix_abundances.tsv]
                                            (Columns corresspond to taxa and rows to samples).

        OPTIONAL ARGUMENTS:
         --result_dir                   Name of directory where the results from all analyses will be written.    [default : results]
         --cpus                         Number of CPUs to use during job                                          [default : all available]
         --memory                       Memory in GB to be asigned for the job                                    [default : 12 GB]
         --help                         Help statement.
        
        PIPELINES:
         qc_classify        :      Pipeline to detect non-viral contamination and viral read classification      (ILLUMINA files required)
         find_viruses       :      Pipeline for viral sequence identification and annotation                     (FASTA file required)
         host_prediction    :      Pipeline to determine virus host pairs using co-ocurrence and phylogeny       (ABUNDANCE tsv matrix
                                                                                                                  PHYlOGENY newik tree
                                                                                                                  HOST TAXONOMY NCBI terms and host ID)

        """
}

// Display help message
if (params.help) {
    helpMessage()
    exit 0
}


println "\n"

log.info """\
                    VIRTOOLS - N F     
         ===================================
         pipeline         : ${params.pipeline}
         result directory : ${params.result_dir}
         cpus             : ${params.cpus}
         """
         .stripIndent()

println "\n"

/*
..................
..Pipeline names..
..................
*/
pipelines = ['qc_classify', 'viral_assembly', 'find_viruses', 'host_prediction']

if (params.pipeline == ''){
  exit 1, "pipeline not specified, use [--pipeline] followed by a valid pipeline name: [qc_classify/viral_assembly/find_viruses/host_prediction]"
} else if(!pipelines.contains(params.pipeline)){
  exit 1, "Invalid pipeline, please select a valid pipeline [qc_classify/viral_assembly/find_viruses/host_prediction]"
}


if (params.pipeline in pipelines){
  println "\u001B[32mProfile: $workflow.profile\033[0m"
  println " "
  println "\033[2mCurrent User: $workflow.userName"
  println "Nextflow-version: $nextflow.version"
  println "Starting time: $nextflow.timestamp"
  println "Workdir location:"
  println "  $workflow.workDir"
  println "Databases location:"
  println "  $params.databases\u001B[0m"
  println " "
}
else{exit 1, "valid pipeline name missing, select one of the following : [find_viruses/qc_classify]"}

/*
..................
..Import modules..
..................
*/
//Programs
include {virsorter2} from './nextflow/modules/virsorter2'
include {checkv} from './nextflow/modules/checkv'
include {viromeQC} from './nextflow/modules/viromeQC'
include {kaiju} from './nextflow/modules/kaiju'
include {FlashWeave} from './nextflow/modules/FlashWeave'
include {fastp} from './nextflow/modules/fastp'
include {megahit} from './nextflow/modules/megahit'

//Databases
include {virsorter_getDB} from './nextflow/modules/downloadvirsorterDB'
include {checkv_getDB} from './nextflow/modules/downloadcheckvDB'
include {kaiju_getDB} from './nextflow/modules/downloadkaijuDB'

//Visualization tools
include {krona} from './nextflow/modules/krona_plot.nf'

/*
......................
..Download Databases..
......................
*/

workflow download_virsorter_db {
    main:
        virsorter_getDB(); db = virsorter_getDB.out
        virsorter_init_DB(db); db = virsorter_init_DB.out
    emit: db    
}

workflow download_checkv_db {
    main:
        checkv_getDB(); db = checkv_getDB.out
    emit: db    
}

workflow download_kaiju_db {
    main:
        kaiju_getDB(); db = kaiju_getDB.out
    emit: db    
}

/*
.........................
..FIND VIRUSES PIPELINE..
.........................
*/

workflow find_viruses {
//    take:
 //      contigs_input_ch
  
    main:
    /*
    ................
    ..Contig input..
    ................
    */
      contigs_input_ch = Channel.fromPath(params.fasta, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()
    
    //Download databases
      if (params.checkvdb) { checkv_db = file(params.checkvdb) } 
      else {download_checkv_db(); checkv_db = download_checkv_db.out }

      //Run programs
//        if (params.virsorterdb) {virsorter_DB = file(params.virsorterdb)}
//        virsorter2(contigs_input_ch,virsorter_DB)
       vs2_ch = virsorter2(contigs_input_ch).view()
       checkv_ch = checkv(vs2_ch, checkv_db).view()
       
        

    emit:
        checkv_db
        vs2_ch
        checkv_ch
}

/*
..............................
..READ QC AND CLASSIFICATION..
..............................
*/

workflow qc_classify {
  
    main:
    //..................
    //..Illumina reads input..
    //...................
      illumina_input_ch = Channel.fromFilePairs(params.reads, checkIfExists: true).view()
    
    //Download databases
      if (params.kaijudb) { kaiju_db = file(params.kaijudb) } 
      else {download_kaiju_db(); kaiju_db = download_kaiju_db.out }

    //Run programs
      vQC_ch = viromeQC(illumina_input_ch).view()
      kaiju_ch=kaiju(illumina_input_ch, kaiju_db).view()
      krona_ch=krona(kaiju_ch).view()


    emit:
        kaiju_db
        kaiju_ch
        krona_ch
        vQC_ch
}

/*
.............................
..ASSEMBLY OF VIRAL CONTIGS..
.............................
*/

workflow viral_assembly {
  
    main:
    //..................
    //..Illumina reads input..
    //...................
      illumina_input_ch = Channel.fromFilePairs(params.reads, checkIfExists: true).view()
    

    //Run programs
      fastp_ch = fastp(illumina_input_ch).view()
      megahit_ch = megahit(fastp_ch).view()


    emit:
        fastp_ch
        megahit_ch
}

/*
......................................
..HOST PREDICTION FROM CO-OCCURENCE ..
......................................
*/
workflow host_prediction {
  
    main:
    //..................
    //..Files input..
    //...................
      matrix_input_ch = Channel.fromPath(params.matrix, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()
      phylum_input_ch = Channel.fromPath(params.phylogeny, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()
      taxonomy_input_ch = Channel.fromPath(params.taxonomy, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()

    //Run programs
      flashweave_qc = FlashWeave(matrix_input_ch).view()


    emit:
      flashweave_qc
}


workflow {
  main:

    if (params.fasta != '' &&  params.pipeline == 'find_viruses') {
      find_viruses()}
    else if (params.pipeline == 'find_viruses'){exit 1, "the find_viruses pipeline requires a FASTA file, use [--fasta]"}

    if (params.reads != '' &&  params.pipeline == 'qc_classify') {
      qc_classify()}
    else if (params.pipeline == 'qc_classify'){exit 1, "the qc_classify pipeline requires a ILLUMINA READ file(S), use [--reads]"}

    if (params.reads != '' &&  params.pipeline == 'viral_assembly') {
      viral_assembly()}
    else if (params.pipeline == 'viral_assembly'){exit 1, "the viral_assembly pipeline requires a ILLUMINA READ file(S), use [--reads]"}

    if (params.matrix != '' &&  params.phylogeny != '' &&  params.matrix != '' && params.pipeline == 'host_prediction'){
      host_prediction()
    }else if (params.pipeline == 'host_prediction'){exit 1, """
    the host_prediction pipeline requires: 
    an abundance TSV MATRIX, use        [--matrix]
    a phylogeny in NEWIK format, use    [--phylogeny]
    a host taxonomy TSV FILE, use       [--taxonomy]
    """}

}

//process runVirSorter2 {

//    container="${params.virsorter2}"
//    tag "Virsorter2 on $params.fasta"
//    input:
//    path contigs from params.fasta
    
//    output:
//    publishDir "${params.virsorter_out}"
    
//    """
//    virsorter run -w ${params.virsorter_out} -i $contigs --min-length 1500 -j ${params.threads} all
//    """
//    }

