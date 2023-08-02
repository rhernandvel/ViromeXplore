process kaiju_getDB {    
    storeDir "${params.databases}/kaiju" 

    output:
        //path ("kaiju_db_viruses.fmi", type: 'file')
        path("kaiju_db_viruses_*", type: 'dir')
    script:
        """
        wget https://kaiju.binf.ku.dk/database/kaiju_db_viruses_2022-03-29.tgz
        mkdir kaiju_db_viruses_2022-03-29
        tar -zxvf kaiju_db_viruses_2022-03-29.tgz -C kaiju_db_viruses_2022-03-29
        rm kaiju_db_viruses_2022-03-29.tgz
        """

}