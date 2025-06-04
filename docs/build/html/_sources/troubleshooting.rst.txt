Troubleshooting
=======================================================

Singularity/Docker Container Download Issues
--------------------------------------------

Sometimes the default directory used by Singularity to store downloaded container images has limited space.  
To resolve this, it's recommended to set the environment variable `SINGULARITY_CACHEDIR` to a directory with more available storage.

Example:

.. code-block:: bash

   export SINGULARITY_CACHEDIR=/path/to/large/disk

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
