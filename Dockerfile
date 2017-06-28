FROM ubuntu:16.04

LABEL maintainer "Jimmy Lee"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        rsync \
        software-properties-common \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 --no-cache-dir install --upgrade \
        pip \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
        pandas \
        Pillow \
        && \
    python3 -m ipykernel.kernelspec

# Install TensorFlow CPU version from central repo
RUN pip3 --no-cache-dir install \
    https://bazel.blob.core.windows.net/tensorflow/tensorflow-1.2.1-cp35-cp35m-linux_x86_64.whl

RUN ln -s /usr/bin/python3 /usr/bin/python

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Set up our notebook config.
COPY jupyter/jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY jupyter/run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh", "--allow-root"]
