# Docker file for Parflow

ARG BASE_IMAGE=ubuntu:20.04

FROM ${BASE_IMAGE} as build
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        git \
        wget \
        ca-certificates \
        build-essential \
        gfortran \
        libopenblas-dev \
        liblapack-dev \
        libopenmpi-dev \
        openmpi-bin \
        tcl-dev \
        tk-dev \
        cmake && \
    rm -rf /var/lib/apt/lists/*

# ParFlow environment variables
ENV HYPRE_DIR=/hypre
ENV PARFLOW_DIR=/parflow

# Install hypre
RUN wget -q https://github.com/hypre-space/hypre/archive/v2.18.2.tar.gz && \
    tar xf v2.18.2.tar.gz && \
    cd hypre-2.18.2/src && \
    ./configure --prefix=/hypre --with-MPI && \
    make install && \
    cd / && \
    rm -fr hypre-2.18.2 v2.18.2.tar.gz

# Install parflow
RUN git clone -b master --single-branch https://github.com/parflow/parflow.git /parflow-tmp

RUN mkdir -p /build && \
    cd /build && \
    cmake ../parflow-tmp \
       -DPARFLOW_AMPS_LAYER=mpi1 \
       -DPARFLOW_AMPS_SEQUENTIAL_IO=TRUE \
       -DHYPRE_ROOT=/hypre \
       -DPARFLOW_ENABLE_TIMING=TRUE \
       -DPARFLOW_HAVE_CLM=TRUE \
       -DCMAKE_INSTALL_PREFIX=/parflow && \
    make install && \
    cd / && \
    rm -fr /parflow-tmp /build

FROM ${BASE_IMAGE}
LABEL maintainer="patrick.avery@kitware.com" \
      version="1.0" \
      parflow.version="master"

COPY --from=build /parflow /parflow

ENV PARFLOW_DIR=/parflow

# Install required runtime files
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        openmpi-bin \
        libgfortran-9-dev \
        openssh-server \
        tcl && \
    rm -rf /var/lib/apt/lists/*

# FIXME: when we update to a new enough version of openmpi, use the
# environment variables below instead of --allow-run-as-root argument.
# Allow root to mpiexec (not in current openmpi version for Ubuntu 18.04)
#ENV OMPI_ALLOW_RUN_AS_ROOT=1
#ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

ENV PARFLOW_MPIEXEC_EXTRA_FLAGS "--mca mpi_yield_when_idle 1 --oversubscribe --allow-run-as-root"

ENTRYPOINT ["tclsh"]
