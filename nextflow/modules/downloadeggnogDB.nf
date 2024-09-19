process eggnog_getDB {    
    storeDir "${params.databases}/eggnog" 

    output:
        path("eggnog_data", type: 'dir')
    script:
        """
        mkdir -p eggnog_data
        cd eggnog_data
        wget http://eggnog6.embl.de/download/emapperdb-5.0.2/eggnog_proteins.dmnd.gz
        gunzip eggnog_proteins.dmnd.gz
        wget http://eggnog6.embl.de/download/emapperdb-5.0.2/eggnog.db.gz
        gunzip eggnog.db.gz
        wget http://eggnog6.embl.de/download/emapperdb-5.0.2/eggnog.taxa.tar.gz
        tar -xzf eggnog.taxa.tar.gz && rm eggnog.taxa.tar.gz
        """

}
