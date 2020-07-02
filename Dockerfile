FROM modulator:latest

MAINTAINER Fenglin Chen <f73chen@uwaterloo.ca>

# packages should already be set up in modulator:latest
USER root

# move in the yaml to build modulefiles from
COPY wgs_pipeline.yaml /modulator/code/gsi/recipe.yaml
COPY bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm /build_files/bcl2fastq2-v2.20.0.422-Linux-x86_64.rpm
COPY bcl2fastq2-v2.18.0.12-Linux-x86_64.rpm /build_files/bcl2fastq2-v2.18.0.12-Linux-x86_64.rpm

# install the programs required for the yaml build
RUN apt-get -m update && apt-get install -y rpm2cpio cpio

# build the modules and set folder & file permissions
RUN ./build-local-code /modulator/code/gsi/recipe.yaml --initsh /usr/share/modules/init/sh --output /modules && \
	find /modules -type d -exec chmod 777 {} \; && \
	find /modules -type f -exec chmod 777 {} \;

# NOTE: to build new module versions, add another RUN layer or rebuild completely

# add the user
RUN groupadd -r -g 1000 ubuntu && useradd -r -g ubuntu -u 1000 ubuntu
USER ubuntu

# copy the setup file to load the modules at startup
COPY .bashrc /home/ubuntu/.bashrc

CMD /bin/bash
