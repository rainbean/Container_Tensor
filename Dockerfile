FROM nvidia/cuda:11.1.1-runtime-ubuntu20.04

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
    apt-get clean && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/*

# upgrade pip3 version for compatibility
RUN pip3 install -q --no-cache-dir --upgrade --only-binary all pip

# install python packages
RUN pip3 install -q --no-cache-dir --only-binary all --compile \
        Cython \
        numba \
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
        opencv-python \
        future \
        jupyterlab \
        ipywidgets

# install pytorch
RUN pip3 install -q --no-cache-dir --only-binary all --compile \
        torch==1.8.2 torchvision==0.9.2 --extra-index-url https://download.pytorch.org/whl/lts/1.8/cu111

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
