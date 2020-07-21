FROM modulator:latest

MAINTAINER Fenglin Chen <f73chen@uwaterloo.ca>

# packages should already be set up in modulator:latest
USER root

# move in the yaml to build modulefiles from
COPY recipes/wgs_pipeline_recipe_basic.yaml /modulator/code/gsi/recipe_basic.yaml

# build the modules and set folder & file permissions
RUN ./build-local-code /modulator/code/gsi/recipe_basic.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# install the programs required for bcl2fastq build
RUN apt-get -m update && apt-get install -y rpm2cpio cpio

# copy in the files required to build some modules
COPY build_files/faSplit-20200114T16_09 /build_files/faSplit-20200114T16_09
COPY build_files/vep_hg19_filter_somaticsites.sh /build_files/vep_hg19_filter_somaticsites.sh
COPY build_files/GenomeAnalysisTK.jar /build_files/GenomeAnalysisTK.jar
COPY build_files/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm /build_files/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm
COPY build_files/bcl2fastq2-v2.18.0.12-Linux-x86_64.rpm /build_files/bcl2fastq2-v2.18.0.12-Linux-x86_64.rpm

# move in the second yaml to build modulefiles from
COPY recipes/wgs_pipeline_recipe_main.yaml /modulator/code/gsi/recipe_main.yaml

RUN ./build-local-code /modulator/code/gsi/recipe_main.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# add final batch of modules here

# install required packages
RUN apt-get -m update && apt-get install -y gzip zip unzip

# copy the setup file to load the modules at startup
COPY build_files/.bashrc /root/.bashrc

# add the user
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

# copy the setup file to load the modules at startup
COPY build_files/.bashrc /home/ubuntu/.bashrc

CMD /bin/bash
