FROM nvidia/cuda:10.1-runtime-ubuntu18.04

LABEL maintainer "Jimmy Lee"

# Reference
#   https://towardsdatascience.com/how-to-shrink-numpy-scipy-pandas-and-matplotlib-for-your-data-product-4ec8d7e86ee4
#   https://github.com/szelenka/shrink-linalg/blob/master/Dockerfile

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
        polyline \
        scikit-image \
        scikit-learn \
        tensorboard \
        opencv-python \
        torch \
        torchvision \
        xlsx2csv \
        piexif \
        tifffile \
        future \
        pyclipper

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/
