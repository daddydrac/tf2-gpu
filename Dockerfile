FROM nvidia/cuda:10.1-cudnn8-runtime-ubuntu18.04
ENV DEBIAN_FRONTEND noninteractive
# Core Linux Deps
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --fix-missing --no-install-recommends apt-utils \
        build-essential \
        curl \
	binutils \
	gdb \
        git \
	freeglut3 \
	freeglut3-dev \
	libxi-dev \
	libxmu-dev \
	gfortran \
        pkg-config \
	python-numpy \
	python-dev \
	python-setuptools \
	libboost-python-dev \
	libboost-thread-dev \
        pbzip2 \
        rsync \
        software-properties-common \
        libboost-all-dev \
        libopenblas-dev \ 
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
	libgraphicsmagick1-dev \
        libavresample-dev \
        libavformat-dev \
        libhdf5-dev \
        libpq-dev \
	libgraphicsmagick1-dev \
	libavcodec-dev \
	libgtk2.0-dev \
	liblapack-dev \
        liblapacke-dev \
	libswscale-dev \
	libcanberra-gtk-module \
        libboost-dev \
	libboost-all-dev \
        libeigen3-dev \
	wget \
        vim \
        qt5-default \
        unzip \
	zip \ 
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*  && \
    apt-get clean && rm -rf /tmp/* /var/tmp/*


# Fix conda errors per Anaconda team until they can fix
RUN mkdir ~/.conda

# Install Anaconda
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
/bin/bash Miniconda3-latest-Linux-x86_64.sh -f -b -p /opt/conda && \
rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH


# For CUDA profiling, TensorFlow requires CUPTI.
# ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64

ARG PYTHON=python3
ARG PIP=pip3


# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8


RUN apt-get update && apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip


RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools \
    hdf5storage \
    h5py \
    py3nvml \
    scikit-learn \
    matplotlib \
    pyinstrument

# Add auto-complete to Juypter
RUN pip install jupyter-tabnine
RUN pip install cupy-cuda101
RUN pip install mlflow 
RUN pip install seldon-core 
RUN pip install shap 
RUN pip install tensor-sensor 
RUN pip install fastapi
RUN pip install tensorflow
RUN pip install dask-cuda
RUN pip install dask-ml 
RUN pip install wandb 
RUN pip install dask-optuna 
RUN pip install optuna 
RUN pip install jupyter-bokeh 
RUN pip install bokeh 
RUN pip install yellowbrick 
RUN pip install hiplot-mlflow 
RUN pip install mlflow-extend 
RUN pip install seldon-deploy-sdk 
RUN pip install jupyterlab
RUN pip install s3contents
RUN pip install hybridcontents
RUN pip install s3fs

RUN conda update -n base -c defaults conda
RUN conda install -c anaconda jupyter 

RUN conda update conda
RUN conda update --all
RUN conda install numba
RUN conda install -c anaconda ipykernel 
RUN conda install -c anaconda seaborn 
RUN conda install -c anaconda ipython
RUN conda install -c conda-forge tensorboard
RUN conda install dask
RUN conda install dask-kubernetes -c conda-forge
RUN conda install ipykernel



WORKDIR /app
EXPOSE 8888 6006
ENV PATH="$HOME/.local/bin:$PATH"

# Better container security versus running as root
RUN useradd -ms /bin/bash container_user


#CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter lab --notebook-dir=/app --ip 0.0.0.0 --no-browser --allow-root --config=/usr/local/etc/jupyter/jupyter_notebook_config.py --NotebookApp.custom_display_url='http://localhost:8888'"]

COPY prepare.sh /prepare.sh

ENTRYPOINT ["bash", "-c", "/prepare.sh"]

CMD ["bash", "-c", "source /etc/bash.bashrc && jupyter lab --notebook-dir=/app --ip 0.0.0.0 --no-browser --allow-root --config=/usr/local/etc/jupyter/jupyter_notebook_config.py --NotebookApp.custom_display_url='http://localhost:8888'"]


