FROM ppc64le/centos:7

# Inspired by linux-anvil from conda-forge
# https://github.com/conda-forge/docker-images

# Install basic requirements.
RUN yum update -y && \
    yum install -y \
        bzip2 \
        make \
        openssl \
        patch \
        sudo \
        tar \
        which && \
    yum clean all

# Download and install tini for zombie reaping.
RUN curl -s -L -O https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    openssl md5 tini | grep 07b74be7c14bae738afff855eb24e0d9 && \
    chmod +x tini && \
    mv tini /usr/local/bin

# Install the latest Miniconda with Python 3 and update everything.
RUN curl -s -L https://repo.continuum.io/miniconda/Miniconda3-4.3.14-Linux-ppc64le.sh > miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    export PATH=/opt/conda/bin:$PATH && \
    conda config --set show_channel_urls True && \
    conda update --all --yes

# Install conda-build
RUN export PATH="/opt/conda/bin:${PATH}" && \
    conda install --yes conda-build anaconda-client

# Install build tools
RUN yum update -y && \
    yum install -y \
        gcc \
        gcc-c++ \
        gfortran \
        git \
        libgfortran \
        unzip \
        vim \
        zip && \
    yum clean all

# Install java 8 (for bazel/tensorflow)
RUN yum update -y && \
    yum install -y \
        java-1.8.0-openjdk-devel && \
    yum clean all

ENV PATH="/opt/conda/bin:${PATH}"
CMD [ "/bin/bash" ]
