FROM continuumio/miniconda3
ARG conda_env=finlab

RUN apt update && apt install -y gcc g++

ENV PYTHON_PATH=/opt/conda/envs/$conda_env/bin/python

COPY environments.yml .
RUN conda env create --name $conda_env -f environments.yml
RUN rm environments.yml

## ADD CONDA ENV PATH TO LINUX PATH 
ENV PATH /opt/conda/envs/$conda_env/bin:$PATH
ENV CONDA_DEFAULT_ENV $conda_env

## MAKE ALL BELOW RUN COMMANDS USE THE NEW CONDA ENVIRONMENT
RUN echo "source activate $conda_env" >> ~/.bashrc

COPY requirements.txt .
RUN python -m pip install -r requirements.txt
RUN rm requirements.txt
RUN python -m pip install jupyterlab
ENV SHELL=/bin/bash

COPY check.py .
RUN python check.py

ENTRYPOINT ["python", "-m", "jupyter", "lab", "--ip='*'", "--NotebookApp.token=''", "--NotebookApp.password=''", "--allow-root"]