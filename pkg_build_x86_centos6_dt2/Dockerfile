FROM toopher/centos-i386:centos6

MAINTAINER Jonathan J. Helmus <jjhelmus@gmail.com>

# Inspired by linux-anvil from conda-forge
# https://github.com/conda-forge/docker-images

ENV LANG en_US.UTF-8

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

# Install basic requirements.
RUN yum update -y && \
    yum install -y \
                   bzip2 \
                   make \
                   patch \
                   sudo \
                   tar \
                   which \
                   libXext-devel \
                   libXrender-devel \
                   libSM-devel \
                   libX11-devel \
                   mesa-libGL-devel && \
    yum clean all

# Install devtoolset 2.
RUN yum update -y && \
    yum install -y \
                   centos-release-scl \
                   yum-utils && \
    yum-config-manager --add-repo http://people.centos.org/tru/devtools-2/devtools-2.repo && \
    yum update -y && \
    yum install -y \
                   devtoolset-2-binutils \
                   devtoolset-2-gcc \
                   devtoolset-2-gcc-c++ && \
    yum clean all

# Download and install tini for zombie reaping.
RUN curl -s -L https://github.com/krallin/tini/releases/download/v0.15.0/tini-i386 > tini && \
    openssl md5 tini | grep 5f358f17619d3ff0fc36e91dd0e07cf5 && \
    chmod +x tini && \
    mv tini /usr/local/bin

# Install the latest Miniconda with Python 3 and update everything.
RUN curl -s -L https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86.sh > miniconda.sh && \
    openssl md5 miniconda.sh | grep 657df0098d79b0aa547b401c31ee4e67 && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    export PATH=/opt/conda/bin:$PATH && \
    conda config --set show_channel_urls True && \
    conda update --all --yes && \
    conda clean -tipy

# Install conda-build 2
RUN export PATH="/opt/conda/bin:${PATH}" && \
    conda install --yes conda-build=2 && \
    conda clean -tipsy

# Install git using conda.
RUN export PATH="/opt/conda/bin:${PATH}" && \
    conda install --yes git && \
    conda clean -tipsy

# Add a file for users to source to activate the `conda`
# environment `root` and the devtoolset compiler. Also
# add a file that wraps that for use with the `ENTRYPOINT`.
COPY entrypoint_source /opt/docker/bin/entrypoint_source
COPY entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `root` and the devtoolset compiler.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "linux32", "/usr/local/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
