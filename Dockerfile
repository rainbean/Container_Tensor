FROM nvidia/cuda:9.0-runtime-ubuntu16.04

LABEL maintainer "Jimmy Lee"

# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        bzip2 \
        ca-certificates \
        curl \
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
RUN conda install -q -y \
        python=3.6 \
        jupyterlab \
        matplotlib \
        numpy \
        scipy \
        scikit-learn \
        scikit-image==0.13.1 \
        pandas \
        Pillow \
        tqdm \
        tensorflow-gpu \
        tensorboard \
        cudatoolkit=9.0 \

# install pytorch
RUN conda install -y -q pytorch torchvision -c pytorch
RUN conda install -y -q tensorboardX -c conda-forge

# Suppress pip deprecation warning 
COPY pip.conf /root/.pip/

# Assign default matplotlib backend to Agg
COPY matplotlibrc /root/.config/matplotlib/

# Set up jupyer notebook config.
RUN python -m ipykernel.kernelspec
COPY jupyter/jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /mnt

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY jupyter/run_jupyter.sh /

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR "/mnt"

CMD ["/run_jupyter.sh", "--allow-root", "--no-browser"]
