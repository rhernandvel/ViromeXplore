process checkv_getDB {    
    storeDir "${params.databases}/checkv" 
    label "checkv_db"

    output:
        path("checkV_db.qza", type: 'dir')
    script:
        """
        qiime viromics checkv-fetch-db --o-database checkV_db.qza --verbose
        """

}
