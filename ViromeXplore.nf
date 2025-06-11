#! /usr/bin/env nextflow
nextflow.enable.dsl=2
params.help = false

def helpMessage() {
  log.info """
                    ViromeXplore
        ===================================
        USAGE:
        Run the workflow as follows:

        nextflow ViromeXplore.nf --pipeline "valid_pipeline_name" --contigs/reads 'file.fasta/file(s).fq' 

        MANDATORY ARGUMENTS:
         --pipeline                     Valid pipeline name                   [qc_classify/viral_assembly/find_viruses/high_quality_genomes/taxonomy_annotation/host_prediction]
         
         For the qc_classify and viral_assembly pipelines:
         --reads                        Reads FASTQ format                                                       ['basename_{1,2}.fastq']
        
         For the find_viruses and annotate pipelines 
         --contigs                      Contigs file in FASTA format                                             ['file.fasta']
 
         For the high_quality_genomes pipeline:
         --reads                        Reads FASTQ format                                                       ['basename_{1,2}.fastq']
         --contigs                      Contigs file obatined from assembly                                      ['file.fasta']
         --viral_contigs                Viral classified contigs or genomes to extend                            ['file.fasta']

         For the taxonomy_annotation pipeline:
         --viral_contigs                Viral classified contigs or genomes                                      ['file.fasta']


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
         qc_classify          :      Pipeline to detect non-viral contamination and viral read classification     (ILLUMINA files required)
         viral_assembly       :      Pipeline for virome read qc and assembly                                     (ILLUMINA files required)
         find_viruses         :      Pipeline for viral sequence identification and annotation                    (FASTA contig file required)
         high_quality_genomes :      Pipeline for obtaining viral contig abbundance and improving genomes         (FASTA contig file required,
                                                                                                                  FASTA viral contig file required,
                                                                                                                  ILLUMINA files required)
         taxonomy_annotation  :      Pipeline for asigning viral contigs/genomes taxonomy and gene annotations    (FASTA viral contig/genome file required)
         host_prediction      :      Pipeline to determine virus host pairs using co-ocurrence and phylogeny      (ABUNDANCE tsv matrix
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
                    ViromeXplore     
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
pipelines = ['qc_classify', 'viral_assembly', 'find_viruses', 'high_quality_genomes', 'taxonomy_annotation', 'host_prediction']

if (params.pipeline == ''){
  exit 1, "pipeline not specified, use [--pipeline] followed by a valid pipeline name: [qc_classify/viral_assembly/find_viruses/high_quality_genomes/taxonomy_annotation/host_prediction]"
} else if(!pipelines.contains(params.pipeline)){
  exit 1, "Invalid pipeline, please select a valid pipeline [qc_classify/viral_assembly/find_viruses/high_quality_genomes/taxonomy_annotation/host_prediction]"
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
//include {FlashWeave} from './nextflow/modules/FlashWeave'
include {fastp} from './nextflow/modules/fastp'
include {megahit} from './nextflow/modules/megahit'
include {bowtie2} from './nextflow/modules/bowtie2'
include {samtools} from './nextflow/modules/samtools'
include {summarize} from './nextflow/modules/summarize'
include {cobra} from './nextflow/modules/cobra'
include {geNomad} from './nextflow/modules/geNomad'
include {vsearch} from './nextflow/modules/vsearch'
include {eggnog_mapper} from './nextflow/modules/eggnogmapper'
include {cdhit} from './nextflow/modules/cdhit'

//Databases
include {virsorter_getDB} from './nextflow/modules/downloadvirsorterDB'
include {checkv_getDB} from './nextflow/modules/downloadcheckvDB'
include {kaiju_getDB} from './nextflow/modules/downloadkaijuDB'
include {virushost_getDB} from './nextflow/modules/downloadvirushostDB'
include {geNomad_getDB} from './nextflow/modules/downloadgeNomadDB'
include {eggnog_getDB} from './nextflow/modules/downloadeggnogDB'

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

workflow download_virushost_db {
    main:
        virushost_getDB(); db = virushost_getDB.out
    emit: db    
}

workflow download_geNomad_db {
    main:
        geNomad_getDB(); db = geNomad_getDB.out
    emit: db    
}

workflow download_eggnog_db {
    main:
        eggnog_getDB(); db = eggnog_getDB.out
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
      contigs_input_ch = Channel.fromPath(params.contigs, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()
    
    //Download databases
      if (params.checkvdb) { checkv_db = file(params.checkvdb) } 
      else {download_checkv_db(); checkv_db = download_checkv_db.out }

      //Run programs
//        if (params.virsorterdb) {virsorter_DB = file(params.virsorterdb)}
//        virsorter2(contigs_input_ch,virsorter_DB)
       vs2_ch = virsorter2(contigs_input_ch).view()
       checkv_ch = checkv(vs2_ch, checkv_db).view()
       cdhit_ch = cdhit(checkv_ch).view()
       
        

    emit:
        checkv_db
        vs2_ch
        checkv_ch
        cdhit_ch
}


/*
..............................
..HIGH QUALITY VIRAL GENOMES..
..............................
*/

workflow high_quality_genomes {
  
    main:
    //..............................................................
    //.. Quality controlled illumina reads input and viral contigs..
    //..............................................................
      illumina_input_ch = Channel.fromFilePairs(params.reads, checkIfExists: true).view()
      contigs_input_ch = Channel.fromPath(params.contigs, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()
      viral_contigs_ch = Channel.fromPath(params.viral_contigs, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()

    

    //Run programs
      bowtie_ch = bowtie2(contigs_input_ch, illumina_input_ch).view()
      samtools_ch = samtools(bowtie_ch).view()
      summary_ch = summarize(samtools_ch).view()
      cobra_ch = cobra(summary_ch, viral_contigs_ch, contigs_input_ch, samtools_ch).view()


    emit:
        bowtie_ch
        samtools_ch
        summary_ch
        cobra_ch
}


/*
................................
..TAXONOMY AND GENE ANNOTATION..
................................
*/

workflow taxonomy_annotation {
  
    main:
    //..............................................................
    //.. Viral contigs or genomes as an input..
    //..............................................................
      viral_contigs_ch = Channel.fromPath(params.viral_contigs, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()

    //Download databases
      if (params.virsorterdb) { virushost_db = file(params.virushostdb) } 
      else {download_virushost_db(); virushost_db = download_virushost_db.out }

      if (params.geNomaddb) { geNomad_db = file(params.geNomaddb) } 
      else {download_geNomad_db(); geNomad_db = download_geNomad_db.out }

      if (params.eggnogdb) { eggnog_db = file(params.eggnogdb) } 
      else {download_eggnog_db(); eggnog_db = download_eggnog_db.out }
      

    //Run programs
      geNomad_ch = geNomad(viral_contigs_ch, geNomad_db).view()
      eggnog_mapper_ch=eggnog_mapper(geNomad_ch, eggnog_db).view()
      vsearch_ch = vsearch(geNomad_ch, virushost_db).view()


    emit:
        virushost_db
        geNomad_db
        eggnog_db
        geNomad_ch
        eggnog_mapper
        vsearch_ch



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
      phylogeny_input_ch = Channel.fromPath(params.phylogeny, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()
      taxonomy_input_ch = Channel.fromPath(params.taxonomy, checkIfExists: true).map{file -> tuple(file.simpleName, file)}.view()

    //Run programs
      flashweave_qc = FlashWeave(matrix_input_ch).view()


    emit:
      flashweave_qc
}


workflow {
  main:

    if (params.contigs != '' &&  params.pipeline == 'find_viruses') {
      find_viruses()}
    else if (params.pipeline == 'find_viruses'){exit 1, "the find_viruses pipeline requires a FASTA file, use [--contigs]"}

    if (params.reads != '' &&  params.pipeline == 'qc_classify') {
      qc_classify()}
    else if (params.pipeline == 'qc_classify'){exit 1, "the qc_classify pipeline requires a ILLUMINA READ file(S), use [--reads]"}

    if (params.reads != '' &&  params.pipeline == 'viral_assembly') {
      viral_assembly()}
    else if (params.pipeline == 'viral_assembly'){exit 1, "the viral_assembly pipeline requires a ILLUMINA READ file(S), use [--reads]"}

     if (params.contigs != '' && params.reads != '' && params.viral_contigs != '' && params.pipeline == 'high_quality_genomes') {
      high_quality_genomes()}
    else if (params.pipeline == 'high_quality_genomes'){exit 1, """
    the viral_assembly pipeline requires:
    ILLUMINA READ files, use [--reads]
    an assembly contig FASTA file, use [--contigs] 
    a viral contig or genome FASTA file, use [--viral_contigs]
    """}

    if (params.viral_contigs != '' &&  params.pipeline == 'taxonomy_annotation') {
      taxonomy_annotation()}
    else if (params.pipeline == 'taxonomy_annotation'){exit 1, "the taxonomy_annotation pipeline requires a viral contig or genome FASTA file, use [--viral_contigs]"}

    if (params.matrix != '' &&  params.phylogeny != '' &&  params.matrix != '' && params.pipeline == 'host_prediction'){
      host_prediction()
    }else if (params.pipeline == 'host_prediction'){exit 1, """
    the host_prediction pipeline requires: 
    an abundance TSV MATRIX, use        [--matrix]
    a phylogeny in NEWIK format, use    [--phylogeny]
    a host taxonomy TSV FILE, use       [--taxonomy]
    """}

}


