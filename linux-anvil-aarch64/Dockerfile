FROM continuumio/miniconda3 as builder

RUN conda install constructor

ADD constructors /opt/constructors

RUN cd /opt/constructors/aarch64 && \ 
    constructor --platform=linux-aarch64 .

FROM arm64v8/centos:7

ADD qemu-aarch64-static /usr/bin/qemu-aarch64-static

LABEL maintainer="conda-forge <conda-forge@googlegroups.com>"

# Set an encoding to make things work smoothly.
ENV LANG en_US.UTF-8

# Add a timestamp for the build. Also, bust the cache.
# ADD https://now.httpbin.org/when/now /opt/docker/etc/timestamp

# Resolves a nasty NOKEY warning that appears when using yum.
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

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

# Run common commands

COPY --from=builder /opt/constructors/aarch64/conda_bootstrap-1.0.0-Linux-aarch64.sh miniconda.sh
COPY scripts/run_commands /opt/docker/bin/run_commands
RUN /opt/docker/bin/run_commands

# Download and cache new compiler packages.
# Should speedup installation of them on CIs.
ENV _channel="jjhelmus/label/aarch64_bootstrap"
RUN source /opt/conda/etc/profile.d/conda.sh && \
    conda activate && \
    conda create -n test --yes --quiet --download-only \
        $_channel::binutils_impl_linux-aarch64 \
        $_channel::binutils_linux-aarch64 \
        $_channel::gcc_impl_linux-aarch64 \
        $_channel::gcc_linux-aarch64 \
        $_channel::gfortran_impl_linux-aarch64 \
        $_channel::gfortran_linux-aarch64 \
        $_channel::gxx_impl_linux-aarch64 \
        $_channel::gxx_linux-aarch64 \
        $_channel::libgcc-ng \
        $_channel::libgfortran-ng \
        $_channel::libstdcxx-ng && \
    conda remove --yes --quiet -n test --all && \
    conda clean -tsy && \
    chgrp -R lucky /opt/conda && \
    chmod -R g=u /opt/conda

# Add a file for users to source to activate the `conda`
# environment `base`. Also add a file that wraps that for
# use with the `ENTRYPOINT`.
COPY linux-anvil-aarch64/entrypoint_source /opt/docker/bin/entrypoint_source
COPY scripts/entrypoint /opt/docker/bin/entrypoint

# Ensure that all containers start with tini and the user selected process.
# Activate the `conda` environment `base` and the devtoolset compiler.
# Provide a default command (`bash`), which will start if the user doesn't specify one.
ENTRYPOINT [ "/opt/conda/bin/tini", "--", "/opt/docker/bin/entrypoint" ]
CMD [ "/bin/bash" ]
