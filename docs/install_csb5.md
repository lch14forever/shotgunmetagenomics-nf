# Setting up the pipeline on GIS computing resources

To start using the this pipeline, follow the steps below:

1. [Install Nextflow](#1-install-nextflow)
1. [Install the pipeline](#2-install-the-pipeline)
1. [Pipeline configuration](#3-pipeline-configuration)
    * [Software deps: Docker and Singularity](#31-software-deps-docker-and-singularity)
    * [Software deps: Bioconda](#32-software-deps-bioconda)
    * [Configuration profiles](#33-configuration-profiles)
1. [Reference databases](#4-reference-files)


## 1) Install NextFlow

Nextflow runs on most POSIX systems (Linux, Mac OSX etc). It can be installed by running the following commands:

```bash
# Make sure that Java v8+ is installed:
java -version
## On a Ubuntu machine (aws), this can be installed with `sudo apt install openjdk-8-jre-headless`

# Install Nextflow
curl -fsSL get.nextflow.io | bash

# Add Nextflow binary to your PATH:
mv nextflow ~/bin
# OR system-wide installation:
# sudo mv nextflow /usr/local/bin
```

See [nextflow.io](https://www.nextflow.io/) for further instructions on how to install and configure Nextflow.

**Special note on GIS cluster**: put the following command in your `.bashrc` file.

```bash
export NXF_JAVA_HOME=/etc/alternatives/java_sdk_1.8.0/
```

## 2) Install the pipeline

Use git to clone the pipeline repository

```
git clone https://github.com/lch14forever/shotgunmetagenomics-nf.git
```

## 3) Pipeline configuration

By default, the pipeline runs with the `standard` configuration
profile. This uses a number of sensible defaults for process
requirements and is suitable for running on a simple (if powerful!)
basic server. You can see this configuration in
[`conf/base.config`](../conf/base.config).

Be warned of two important points about this default configuration:

1. The default profile uses the `local` executor
    * All jobs are run in the login session. If you're using a simple
      server, this may be fine. If you're using a compute cluster,
      this is bad as all jobs will run on the head node.
    * See the
      [nextflow docs](https://www.nextflow.io/docs/latest/executor.html)
      for information about running with other hardware backends. Most
      job scheduler systems are natively supported.
2. Nextflow will expect all software to be installed and available on the `PATH`

#### 3.1) Software deps: Docker and Singularity 

Running the pipeline with the option `-with-singularity` or
`-with-docker` tells Nextflow to enable either
[Singularity](http://singularity.lbl.gov/) or Docker for this run.

All images can be found at [dockerhub](https://hub.docker.com/u/lichenhao)

#### 3.2) Software deps: bioconda

**Special note on GIS cluster**: all environments were configured properly and 
you can use the option `-profile gis` to run it.

Alternatively, you can use conda to setup the software required. 
All conda environment configuration files are found in [conda/](../conda).

Run the following command to create the environment:
```bash
conda env create -f conda.[software].yaml
```

Run the pipeline with the option `-profile conda`. See the next section for details.

#### 3.3) Configuration profiles

Nextflow can be configured to run on a wide range of different
computational infrastructures. In addition to the above
pipeline-specific parameters it is likely that you will need to define
system-specific options. For more information, please see the
[Nextflow documentation](https://www.nextflow.io/docs/latest/).

Whilst most parameters can be specified on the command line, it is
usually sensible to create a configuration file for your environment.

If you are the only person to be running this pipeline, you can create
your config file as `~/.nextflow/config` and it will be applied every
time you run Nextflow. Alternatively, save the file anywhere and
reference it when running the pipeline with `-c path/to/config`.

If you think that there are other people using the pipeline who would
benefit from your configuration (eg. other common cluster setups),
please let us know. We can add a new configuration and profile which
can used by specifying `-profile <name>` when running the pipeline.

The pipeline comes with several such config profiles - see the
installation appendices and usage documentation for more information.

## 4) Reference files

The tools in the pipeline need databases to be downloaded.
Refer to the the `usage` documents for the database locations 
on [AWS](usage_csb5aws.md) and [GIS cluster](usage_giscluster.md)
