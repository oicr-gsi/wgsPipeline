FROM modulator:latest

MAINTAINER Fenglin Chen <f73chen@uwaterloo.ca>

# packages should already be set up in modulator:latest
USER root

# move in the yaml to build modulefiles from
COPY wgs_pipeline_recipe_basic.yaml /modulator/code/gsi/recipe_basic.yaml

# build the modules and set folder & file permissions
RUN ./build-local-code /modulator/code/gsi/recipe_basic.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# install the programs required for bcl2fastq build
RUN apt-get -m update && apt-get install -y rpm2cpio cpio

# second copy and build layer for the next batch of modules
# COPY wgs_pipeline_recipe_main.yaml /modulator/code/gsi/recipe_main.yaml
COPY failed_only.yaml /modulator/code/gsi/recipe_main.yaml

COPY GenomeAnalysisTK.jar /build_files/GenomeAnalysisTK.jar
COPY bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm /build_files/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm
COPY bcl2fastq2-v2.18.0.12-Linux-x86_64.rpm /build_files/bcl2fastq2-v2.18.0.12-Linux-x86_64.rpm

RUN ./build-local-code /modulator/code/gsi/recipe_main.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# add final batch of modules here

# install required packages
RUN apt-get -m update && apt-get install -y gzip zip unzip

# add the user
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

# copy the setup file to load the modules at startup
COPY .bashrc /home/ubuntu/.bashrc

CMD /bin/bash
