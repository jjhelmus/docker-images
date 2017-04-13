FROM ppc64le/ubuntu:14.04

# Inspired by linux-anvil from conda-forge
# https://github.com/conda-forge/docker-images

# Install basic requirements.
RUN apt-get update && \
    apt-get install --yes \
        curl \
        wget

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
RUN apt-get update && \
    apt-get install --yes \
        automake \
        build-essential \
        gfortran \
        git \
        libncurses-dev \
        libtool \
        pkg-config \
        unzip \
        vim \
        zip

ENV PATH="/opt/conda/bin:${PATH}"
CMD [ "/bin/bash" ]
