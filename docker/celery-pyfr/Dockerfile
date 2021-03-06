# Docker file for celery + PyFR 1.8.0

FROM kitware/hpccloud:celery
LABEL maintainer="patrick.oleary@kitware.com" \
      version="1.0" \
      pyfr.version="1.8.0"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc-6 \
        g++-6 \
        g++-6-multilib \
        gfortran-6 \
        libopenblas-dev \
        liblapack-dev \
        openssh-client \
        openssh-server \
        openmpi-bin \
        libopenmpi-dev \
        libhdf5-dev \
        libmetis-dev \
        strace \
        unzip \
        wget && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 \
                        --slave /usr/bin/g++ g++ /usr/bin/g++-6 \
                        --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip3 install appdirs \
                 numpy \
                 pytools \
                 mako \
                 gimmik \
                 mpmath \
                 mpi4py \
                 h5py

# Install PyFR 1.8.0
RUN wget -q -O PyFR-1.8.0.zip https://github.com/PyFR/PyFR/archive/v1.8.0.zip && \
    unzip -qq PyFR-1.8.0.zip && \
    cd PyFR-1.8.0 && \
    python3 setup.py install && \
    cd /

RUN chown -R celery  /PyFR-1.8.0
