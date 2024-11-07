process checkv_getDB {    
    storeDir "${params.databases}/checkv" 

    output:
        path("checkv-db-v*", type: 'dir')
    script:
        """
        wget https://portal.nersc.gov/CheckV/checkv-db-v1.0.tar.gz
        tar -zxvf checkv-db-v1.0.tar.gz
        rm checkv-db-v1.0.tar.gz
        """

}
