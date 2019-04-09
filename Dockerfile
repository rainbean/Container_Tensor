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
        h5py \
        tqdm \
        polyline \
        matplotlib \
        Pillow \
        scikit-image \
        scikit-learn \
        tensorflow \
        tensorboard \
        opencv-python \
        https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl \
        torchvision \
        tensorboardX

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/
