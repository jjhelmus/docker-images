FROM ppc64le/centos:7

MAINTAINER conda-forge <conda-forge@googlegroups.com>

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

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

# Run common commands
COPY scripts/run_commands /opt/docker/bin/run_commands
RUN /opt/docker/bin/run_commands

# Add a file for users to source to activate the `conda`
# environment `root`. Also add a file that wraps that for
# use with the `ENTRYPOINT`.
COPY linux-anvil2/entrypoint_source /opt/docker/bin/entrypoint_source
COPY scripts/entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `root`.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
