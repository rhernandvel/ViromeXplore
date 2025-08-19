Troubleshooting
=======================================================

Singularity/Docker Container Download Issues
--------------------------------------------

Sometimes the default directory used by Singularity to store downloaded container images has limited space.  
To resolve this, it's recommended to set the environment variable `SINGULARITY_CACHEDIR` to a directory with more available storage.

Example:

.. code-block:: bash

   export SINGULARITY_CACHEDIR=/path/to/large/disk


When using an HPC system, compute nodes often do **not** have internet access, unlike login nodes.  
In such cases, container images (Docker or Singularity) may need to be downloaded manually.  

If the container images cannot be pulled automatically, you can fetch them in advance using commands like:

.. code-block:: bash

   # For Singularity
   singularity pull docker://<image_name>:<tag>

   # For Docker
   docker pull <image_name>:<tag>

.. note::

   It is **not necessary** to download all container images.  
   Only those used by the pipeline(s) of interest need to be fetched.  

The list of images currently used in the latest release can be found in the 
``containers.config`` file `on GitHub <https://github.com/rhernandvel/ViromeXplore/blob/master/nextflow/config/containers.config>`_

For example: to manually download the VirSorter2 container (version 2.2.3):

.. code-block:: bash

   # Singularity
   singularity pull docker://jiarong/virsorter:2.2.3

   # Docker
   docker pull jiarong/virsorter:2.2.3


Only Forward Reads Are Passed to Workflows
------------------------------------------

This typically occurs when quotation marks are missing from the `--reads` parameter in your Nextflow command.  
Make sure to enclose the regular expression in quotes.

Correct usage:

.. code-block:: bash

   nextflow ViromeXplore.nf --pipeline qc_classify --reads "basename_{1,2}.fastq"

Input File Naming
-----------------

Some tools automatically generate directories and output files based on input filenames.  
To avoid unexpected behavior, it's best to avoid using dots (`.`) in filenames except for the extension.

**Recommended:**

- ✅ `sample1.fastq`
- ✅ `demo_SRR829034_1.fastq`

**Avoid:**

- ❌ `sample.v1.fastq`
