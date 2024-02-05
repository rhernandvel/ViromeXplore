#! /usr/bin/env nextflow
nextflow.enable.dsl=2
params.help = false

def helpMessage() {
  log.info """
                   VIRTOOLS - N F 
        ===================================
        Usage:
        Run the workflow as follows:

        nextflow run viromics.nf --pipeline "valid_pipeline_name" --fasta/reads 'file.fasta/file(s).fq' 

        Mandatory arguments:
         --pipeline                     Valid pipeline name                                                     [find_viruses/qc_classify]
         --fasta/reads                  Contigs file in FASTA format /  reads FASTQ format              ['file.fasta'/'basename_{1,2}.fastq']

        Optional arguments:
         --result_dir                   Name of directory where the results from all analyses will be written.  [default : results]
         --cpus                         Number of CPUs to use during job                                        [default : all available]
         --memory                       Memory in GB to be asigned for the job                                  [default : 12 GB]
         --help                         Help statement.
        
        Pipelines:
         find_viruses       :      Pipeline for viral sequence identification and annotation                     (FASTA file required)
         qc_classification  :      Pipeline to detect non-viral contamination and viral read classification      (ILLUMINA files required)
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
         fasta/reads      : ${params.fasta}${params.reads}
         cpus             : ${params.cpus}
         """
         .stripIndent()

println "\n"

/*
..................
..Pipeline names..
..................
*/
pipelines = ['find_viruses', 'qc_classify']

if (params.pipeline == ''){
  exit 1, "pipeline not specified, use [--pipeline] followed by a valid pipeline name: [find_viruses/qc_classify]"
}

if (params.fasta == '' &&  params.reads == '' ) {
  exit 1, "input files missing, use [--fasta] or [--reads]"

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

workflow {
  main:

    if (params.fasta != '' &&  params.pipeline == 'find_viruses') {
      find_viruses()}
    else if (params.pipeline == 'find_viruses'){exit 1, "the find_viruses pipeline requires a FASTA file, use [--fasta]"}

    if (params.reads != '' &&  params.pipeline == 'qc_classify') {
      qc_classify()}
    else if (params.pipeline == 'qc_classify'){exit 1, "the qc_classify pipeline requires a ILLUMINA READ file(S), use [--reads]"}


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

