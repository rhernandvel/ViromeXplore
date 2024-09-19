process geNomad_getDB {    
    storeDir "${params.databases}/geNomad" 

    output:
        path("genomad_db", type: 'dir')
    script:
        """
        wget https://portal.nersc.gov/genomad/__data__/genomad_db_v1.7.tar.gz
        tar -xzf genomad_db_v1.7.tar.gz && rm genomad_db_v1.7.tar.gz
        """

}
