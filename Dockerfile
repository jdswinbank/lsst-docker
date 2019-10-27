# syntax=docker/dockerfile:experimental
ARG LSST_TAG=w_latest
FROM lsstsqre/centos:${LSST_TAG}
ARG LSST_TAG

LABEL maintainer="John Swinbank <swinbank@lsst.org>"

USER root
RUN yum -y install stow zip unzip




USER lsst
ENV LSST_TAG ${LSST_TAG}
COPY source_lsst.sh /etc/profile.d
COPY bash_local /home/lsst/.bash_local
RUN conda config --set changeps1 false
RUN conda install ipython
WORKDIR /home/lsst
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts
RUN --mount=type=ssh,uid=1000 git clone git@bitbucket.org:jdswinbank/dotfiles.git
RUN rm .bashrc .bash_profile
WORKDIR /home/lsst/dotfiles
RUN make install-readline
RUN make install-bash
WORKDIR /home/lsst
