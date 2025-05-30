process kaiju_getDB {    
    storeDir "${params.databases}/kaiju" 

    output:
        //path ("kaiju_db_viruses.fmi", type: 'file')
        path("kaiju_db_viruses_*", type: 'dir')
    script:
        """
        wget https://kaiju-idx.s3.eu-central-1.amazonaws.com/2024/kaiju_db_viruses_2024-08-15.tgz
        mkdir kaiju_db_viruses_2024-08-15
        tar -zxvf kaiju_db_viruses_2024-08-15.tgz -C kaiju_db_viruses_2024-08-15
        rm kaiju_db_viruses_2024-08-15.tgz
        """

}
