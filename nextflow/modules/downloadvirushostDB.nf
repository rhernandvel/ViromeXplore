process virushost_getDB {    
    storeDir "${params.databases}/virushost" 

    output:
        path ("virushostdb.formatted.genomic.fna", type: 'file')

    script:
        """
        wget https://www.genome.jp/ftp/db/virushostdb/virushostdb.formatted.genomic.fna.gz
        gunzip virushostdb.formatted.genomic.fna.gz
        """

}