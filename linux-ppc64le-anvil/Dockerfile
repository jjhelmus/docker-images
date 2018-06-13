FROM ppc64le/centos:7

MAINTAINER conda-forge <conda-forge@googlegroups.com>


# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

# Add a timestamp for the build. Also, bust the cache.
ADD http://tycho.usno.navy.mil/timer.html /opt/docker/etc/timestamp

# Resolves a nasty NOKEY warning that appears when using yum.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# Install basic requirements.
RUN yum update -y && \
    yum install -y \
                   file \
                   bzip2 \
                   make \
                   patch \
                   sudo \
                   tar \
                   which \
                   libXau \
                   libxcb \
                   libXdmcp \
                   libXext-devel \
                   libXrender-devel \
                   libSM-devel \
                   libX11-devel \
                   libXt \
                   mesa-libGL-devel \
                   mesa-libGLU \
                   openssl \
                   openssh-clients \
                   rsync \
                   util-linux \
                   wget \
                   xorg-x11-server-Xvfb && \
    yum clean all

# give sudo permission for conda user to run yum (user creation is postponed
# to the entrypoint, so we can create a user with the same id as the host)
RUN echo 'conda ALL=NOPASSWD: /usr/bin/yum' >> /etc/sudoers

# Install the latest Miniconda with Python 3 and update everything.
RUN curl -s -L https://repo.continuum.io/miniconda/Miniconda3-4.3.27-Linux-ppc64le.sh > miniconda.sh && \
    openssl md5 miniconda.sh | grep c51bc5fb00da12b487959b5adf0133ab && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    touch /opt/conda/conda-meta/pinned && \
    export PATH=/opt/conda/bin:$PATH && \
    conda config --set show_channel_urls True && \
    conda config --add channels conda-forge && \
    conda config --add channels furmanek && \
    conda update --all --yes && \
    conda clean -tipy

# Install conda build and deployment tools.
RUN export PATH="/opt/conda/bin:${PATH}" && \
    conda install --yes --quiet conda-build anaconda-client jinja2 setuptools && \
    conda install --yes git && \
    conda clean -tipsy

# Install docker tools
RUN export PATH="/opt/conda/bin:${PATH}" && \
    conda install --yes su-exec && \
    export CONDA_SUEXEC_INFO=( `conda list su-exec | grep su-exec` ) && \
    echo "su-exec ${CONDA_SUEXEC_INFO[1]}" >> /opt/conda/conda-meta/pinned && \
    conda clean -tipsy

# Add tini from git
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-ppc64el /tini-ppc64el
RUN chmod +x /tini-ppc64el

# Add a file for users to source to activate the `conda`
# environment `root`. Also add a file that wraps that for
# use with the `ENTRYPOINT`.
COPY entrypoint_source /opt/docker/bin/entrypoint_source
COPY entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `root`.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "/tini-ppc64el", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
