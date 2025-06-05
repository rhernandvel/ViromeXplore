Installation
=======================================================

ViromeXplore requires `Nextflow <https://www.nextflow.io/docs/latest/install.html>`_ and either 
`Singularity <https://docs.sylabs.io/guides/3.0/user-guide/installation.html>`_ (default) or 
`Docker <https://docs.docker.com/engine/install/>`_ to run.

Conda Installation
-----------------------------------

If you **do not have root privileges** and only have access to `conda <https://docs.conda.io/>`_, you can install both Nextflow and Singularity using the following command:

.. code-block:: bash

    conda create -n ViromeXplore-env -c conda-forge -c bioconda singularity nextflow

This method allows ViromeXplore to run entirely within a conda environment.

System Installation
--------------------------------------

Alternatively, if you **have root access**, you can install Nextflow, Singularity, and Docker manually using system-level commands as shown below.

Install Nextflow
^^^^^^^^^^^^^^^^

.. code-block:: bash

   curl -s https://get.nextflow.io | bash
   sudo mv nextflow /usr/local/bin/
   nextflow -version

Install Docker
^^^^^^^^^^^^^^

.. code-block:: bash

   sudo apt-get update
   sudo apt-get install -y \
     ca-certificates curl gnupg lsb-release

   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
   https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

   sudo apt-get update
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   docker --version

Install Singularity
^^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   export VERSION=3.10.3
   wget https://github.com/sylabs/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz
   tar -xzf singularity-${VERSION}.tar.gz
   cd singularity
   ./mconfig && make -C builddir && sudo make -C builddir install
   singularity --version


System Requirements
-----------------------

ViromeXplore has been validated on the following environment:

- Ubuntu 22.04 LTS (x86_64 architecture)

The pipeline is expected to run successfully on other modern Linux distributions