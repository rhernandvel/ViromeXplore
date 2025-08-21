Running ViromeXplore
===============================

Running the Workflows
----------------------

**Usage**

To run the workflows, use the following commands:

.. code-block:: bash

   nextflow ViromeXplore.nf --pipeline qc_classify --reads "basename_{1,2}.fastq"
   nextflow ViromeXplore.nf --pipeline viral_assembly --reads "basename_{1,2}.fastq"
   nextflow ViromeXplore.nf --pipeline find_viruses --contigs contigs.fasta
   nextflow ViromeXplore.nf --pipeline high_quality_genomes --reads "basename_{1,2}.fastq" --contigs contigs.fasta --viral_contigs viral_contigs.fasta
   nextflow ViromeXplore.nf --pipeline taxonomy_annotation --viral_contigs viral_contigs_or_genomes.fasta
   nextflow ViromeXplore.nf --pipeline host_prediction --phylogeny viral_phylogeny.nwk --taxonomy host_taxonomy.tsv --matrix virus_host_abundances.tsv

Containers are available for all processes. Use the appropriate profile to run the workflows:

- For Docker: ``-profile docker``
- For Singularity (default): ``-profile singularity``

If using a cluster system (e.g., SLURM), you can combine profiles to configure resource usage. To do this, modify the ``config/local.config`` file and run using:

.. code-block:: bash

   -profile singularity,slurm
   -profile docker,slurm

Make sure to include the selected profile when running the workflow.

Mandatory Arguments
-------------------

- ``--pipeline``  
  Specifies the pipeline to run. Valid options:  
  ``qc_classify``, ``viral_assembly``, ``find_viruses``, ``high_quality_genomes``, ``taxonomy_annotation``, ``host_prediction``

**For `qc_classify` and `viral_assembly` pipelines**:

- ``--reads``  
  Input reads in FASTQ format, e.g.:  
  ``basename_{1,2}.fastq``

**For `find_viruses` and `taxonomy_annotation` pipelines**:

- ``--contigs``  
  Contigs file in FASTA format, e.g.:  
  ``contigs.fasta``

**For `high_quality_genomes` pipeline**:

- ``--reads``  
  Input reads in FASTQ format: ``basename_{1,2}.fastq``  
- ``--contigs``  
  Contigs file obtained from assembly: ``contigs.fasta``  
- ``--viral_contigs``  
  Viral contigs or genomes: ``viral_contigs.fasta``

**For `taxonomy_annotation` pipeline**:

- ``--viral_contigs``  
  Viral contigs or genomes: ``viral_contigs_or_genomes.fasta``

**For `host_prediction` pipeline**:

- ``--phylogeny``  
  Phylogenetic tree of the viruses (NEWICK format): ``virus_phylogeny.nwk``  
- ``--taxonomy``  
  Lineage of host taxa (tab-delimited): ``taxonomy_file.tsv``  
- ``--matrix``  
  Virus-host abundance matrix (tab-delimited): ``matrix_abundances.tsv``  
  *Columns represent taxa; rows represent samples.*

Optional Arguments
-------------------

- ``--result_dir``  
  Directory to store output files.  
  *Default: ``results``*

- ``--cpus``  
  Number of CPUs to use.  
  *Default: all available*

- ``--memory``  
  Memory (in GB) to allocate.  
  *Default: 12 GB*

- ``--help``  
  Display help message.

- ``--workdir``  
  Work directory for nextflow.
  *Default: work*

Tool-Specific Parameters
------------------------

**ViromeQC**

- ``samp_type``  
  Sample type.  
  *Default: ``environmental``*

**VirSorter2**

- ``virsorter_minlength``  
  Minimum contig length to keep.  
  *Default: ``1500``*

**Fastp**

- ``phred_quality``  
  Minimum phred quality score for filtering.  
  *Default: ``30``*

**MEGAHIT**

- ``kmers_assembly``  
  K-mer sizes to use for assembly.  
  *Default: ``21,35,49,63,77,91,105,119,127``*

**COBRA**

- ``cobra_assembly``  
  Assembly method used.  
  *Default: ``megahit``*

- ``min_kmer``  
  Minimum k-mer size.  
  *Default: ``21``*

- ``max_kmer``  
  Maximum k-mer size.  
  *Default: ``127``*
Custom Database Arguments
-------------------------

By default, ViromeXplore uses bundled reference databases.  
However, users may specify **custom databases** for the following tools:

- ``--virsorterdb``  
  Custom VirSorter2 database path.

- ``--checkvdb``  
  Custom CheckV database path.

- ``--kaijudb``  
  Custom Kaiju database path.

- ``--virushostdb``  
  Custom virus-host database path.

- ``--genomaddb``  
  Custom geNomad database path.

- ``--eggnogdb``  
  Custom EggNOG database path.

.. note::

   All parameters (including defaults and database locations)  
   are defined in the ``nextflow.config`` file.  
   Users may edit this file directly or override parameters via the command line.


Available Pipelines
-------------------

- **qc_classify**  
  Detects non-viral contamination and classifies reads.  
  *(Requires ILLUMINA FASTQ files)*

- **viral_assembly**  
  Performs QC and assembly of virome reads.  
  *(Requires ILLUMINA FASTQ files)*

- **find_viruses**  
  Identifies and annotates viral sequences.  
  *(Requires FASTA contigs file)*

- **high_quality_genomes**  
  Estimates abundance and improves genome completeness.  
  *(Requires FASTA contigs, viral contigs, and ILLUMINA FASTQ files)*

- **taxonomy_annotation**  
  Assigns taxonomy and gene functions to viral genomes.  
  *(Requires FASTA viral contigs/genomes)*

- **host_prediction**  
  Predicts virus-host interactions using abundance, taxonomy, and phylogeny.  
  *(Requires NEWICK tree, taxonomy file, and abundance matrix)*
