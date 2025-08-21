Tools and Databases
===================

ViromeXplore uses the following versions of the bioinformatics tools:

.. list-table::
   :header-rows: 1
   :widths: 25 10 45 20

   * - Software
     - Version
     - Summary
     - Links
   * - VirSorter2
     - 2.2.3
     - Identifies and classifies viral sequences from metagenomic assemblies.
     - `GitHub <https://github.com/jiarong/VirSorter2>`__
   * - CheckV
     - 0.8.1
     - Quality assessment of viral genomes.
     - `Bitbucket <https://bitbucket.org/berkeleylab/checkv>`__
   * - CD-HIT
     - 4.8.1
     - Clustering tool for reducing sequence redundancy.
     - `CD-HIT <https://sites.google.com/view/cd-hit>`__
   * - ViromeQC
     - 1.0.2
     - Benchmark and quantify non-viral contamination.
     - `ViromeQC <http://segatalab.cibio.unitn.it/tools/viromeqc/>`__
   * - Kaiju
     - 1.7.2
     - Taxonomic classification of metagenomic reads.
     - `Kaiju <https://bioinformatics-centre.github.io/kaiju/>`__
   * - Krona
     - 2.8
     - Interactive hierarchical visualization of metagenomic data.
     - `Github <https://github.com/marbl/Krona/wiki>`__
   * - FlashWeave
     - 0.19.2
     - Infers microbial interaction networks from sequencing data.
     - `GitHub <https://github.com/meringlab/FlashWeave>`__
   * - TIM
     - latest
     - Interactions between organisms through phylogeny and co-occurence.
     - `GitHub <https://github.com/RomainBlancMathieu/TIM>`__
   * - fastp
     - 0.20.1
     - FASTQ preprocessing tool (quality filtering, trimming).
     - `GitHub <https://github.com/OpenGene/fastp>`__
   * - MEGAHIT
     - 1.2.9
     - Ultrafast assembler for large and complex metagenomes.
     - `GitHub <https://github.com/voutcn/megahit>`__
   * - Bowtie2
     - 2.4.1
     - Fast and sensitive short-read alignment.
     - `Bowtie2 <http://bowtie-bio.sourceforge.net/bowtie2/>`__
   * - SAMtools
     - 1.9
     - Utilities for manipulating alignments in SAM/BAM formats.
     - `SAMtools <http://www.htslib.org/>`__
   * - MetaBAT2
     - 2.15
     - Genome binning from metagenomic assemblies.
     - `Bitbucket <https://bitbucket.org/berkeleylab/metabat/src/master/>`__
   * - COBRA
     - 1.2.3
     - Higher quality viral genomes assembled from metagenomes.
     - `GitHub <https://github.com/linxingchen/cobra>`__
   * - geNomad
     - 1.8.0
     - Virus identification, classification and annotation tool.
     - `geNomad <https://portal.nersc.gov/genomad/>`__
   * - EggNOG-mapper
     - 2.1.9
     - Functional annotation using orthology assignments.
     - `GitHub <https://github.com/eggnogdb/eggnog-mapper/wiki>`__
   * - VSEARCH
     - 2.10.4
     - Open-source tool for metagenomic clustering, chimera detection, and search.
     - `GitHub <https://github.com/torognes/vsearch>`__



ViromeXplore uses the following reference databases.  

.. list-table::
   :header-rows: 1
   :widths: 25 10 45 20

   * - Database
     - Version
     - Summary
     - Links
   * - CheckV database
     - v1.0
     - Database for viral genome quality assessment with CheckV.
     - `Download <https://portal.nersc.gov/CheckV/checkv-db-v1.0.tar.gz>`__
   * - EggNOG database
     - v5.0.2
     - Orthology-based functional annotation database used by EggNOG-mapper.
     - `Proteins <http://eggnog6.embl.de/download/emapperdb-5.0.2/eggnog_proteins.dmnd.gz>`__, `DB <http://eggnog6.embl.de/download/emapperdb-5.0.2/eggnog.db.gz>`__, `Taxa <http://eggnog6.embl.de/download/emapperdb-5.0.2/eggnog.taxa.tar.gz>`__
   * - geNomad database
     - v1.7
     - Reference database for viral discovery and annotation with geNomad.
     - `Download <https://portal.nersc.gov/genomad/__data__/genomad_db_v1.7.tar.gz>`__
   * - Kaiju virus database
     - 2024-08-15
     - Taxonomic classification database for viral sequences in Kaiju.
     - `Download <https://kaiju-idx.s3.eu-central-1.amazonaws.com/2024/kaiju_db_viruses_2024-08-15.tgz>`__
   * - Virus-Host Database
     - latest
     - Reference database of known virus-host interactions.
     - `Download <https://www.genome.jp/ftp/db/virushostdb/virushostdb.formatted.genomic.fna.gz>`__


.. note::

   Consider citing the tools and databases used in ViromeXplore accordingly.