FROM nvidia/cuda:9.1-cudnn7-runtime-ubuntu16.04

LABEL maintainer "Jimmy Lee"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        bzip2 \
        ca-certificates \
        curl \
        ffmpeg \
        openexr \
        webp \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install mini conda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

# install python packages
RUN conda install -q \
        jupyter \
        matplotlib \
        numpy \
        scipy \
        scikit-learn \
        scikit-image \
        pandas \
        seaborn \
        Pillow \
        tqdm

# install tensorflow, keras and opencv-python
RUN pip --no-cache-dir install \
        Keras \
        https://bazel.blob.core.windows.net/cuda9/tensorflow-1.6.0-cp36-cp36m-linux_x86_64.whl \
        https://bazel.blob.core.windows.net/opencv/opencv_python-3.4.0%2B2329983-cp36-cp36m-linux_x86_64.whl \
        tensorboardX

# install pytorch
RUN conda install -q pytorch torchvision cuda91 -c pytorch

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/

# Set up jupyer notebook config.
RUN python -m ipykernel.kernelspec
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
