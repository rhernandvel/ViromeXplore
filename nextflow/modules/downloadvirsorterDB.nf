process virsorter_getDB {   
  tag "Virsorter2 DB Download"
//  conda 'bwa samtools'
//  label 'virsorter2_db'
  input:
    publishDir "${params.databases}/virsorter/", mode: 'copy', pattern: "virsorterDB"
//    storeDir "${params.databases}/virsorter/virsorterDB"
  output:
    path("virsorterDB", type: 'dir')
    
  script:
    """
    wget https://osf.io/v46sc/download
    tar -xzf download
    mv db virsorterDB
    rm download
    """

  stub:
    """
    mkdir -p virsorterDB
    """
}

process virsorter_init_DB {
  tag "Virsorter2 init DB"
//  label 'virsorter2_db'
  publishDir "${params.databases}/virsorter/", mode: 'copy', pattern: "virsorterDB"
  
  input:
  file(database)
  
  output:
  path("${params.databases}/virsorter/virsorterDB")
 //   path("virsorterDB", type: 'dir')

  script:
    """
    virsorter config --init-source --db-dir=${database}
    """
}
