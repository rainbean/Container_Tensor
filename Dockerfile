FROM nvidia/cuda:10.2-runtime-ubuntu18.04

LABEL maintainer "Jimmy Lee"

# Pick up some dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential gcc gfortran \
        wget bzip2 ca-certificates curl \
        libsm6 libxext6 libxrender1 \
        libgomp1 libglib2.0-0 \
        libopenblas-dev \
        liblapack-dev \
        libgl1-mesa-glx \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        && \
    cd /usr/bin && \
    ln -s python3 python && \
    ln -s pip3 pip && \
    apt-get clean && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*

# upgrade pip3 version for compatibility
RUN pip3 install -q --no-cache-dir --upgrade --only-binary all pip

# install python packages
RUN pip3 install -q --no-cache-dir --only-binary all --compile \
        pip \
        Cython \
        numpy \
        scipy \
        pandas \
        matplotlib \
        Pillow \
        tqdm \
        scikit-image \
        scikit-learn \
        scikit-build \
        tensorboard \
        torch \
        torchvision \
        opencv-python \
        piexif \
        tifffile \
        future \
        fastjsonschema \
        polyline \
        pyclipper

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/
