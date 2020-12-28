FROM nvidia/cuda:11.0-runtime-ubuntu20.04

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

# install python packages
RUN pip3 install --no-cache-dir -q --only-binary all --compile \
        Cython \
        numpy \
        scipy \
        pandas \
        matplotlib \
        Pillow \
        tqdm \
        scikit-image \
        scikit-learn \
        tensorboard \
        opencv-python \
        piexif \
        tifffile \
        future \
        fastjsonschema \
        polyline \
        pyclipper

# specify cuda 11
RUN pip3 install --no-cache-dir -q --only-binary all \
        torch==1.7.1+cu110 \
        torchvision==0.8.2+cu110 \
        -f https://download.pytorch.org/whl/torch_stable.html

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/
