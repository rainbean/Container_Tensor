FROM nvidia/cuda:10.0-runtime-ubuntu18.04

LABEL maintainer "Jimmy Lee"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget bzip2 ca-certificates curl \
        libsm6 libxext6 libxrender1 \
        libgomp1 libglib2.0-0 \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        && \
    cd /usr/bin && ln -s python3 python && ln -s pip3 pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install python packages
RUN pip3 install --no-cache-dir -q --only-binary all \
        numpy \
        scipy \
        pandas \
        tqdm \
        polyline \
        matplotlib \
        Pillow \
        scikit-image \
        scikit-learn \
        tensorboard \
        opencv-python \
        xlsx2csv piexif tifffile future \
        torch \
        torchvision

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/
