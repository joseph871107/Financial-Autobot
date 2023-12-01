FROM continuumio/miniconda3

RUN apt update && apt install -y gcc g++

ENV PYTHON_PATH=/opt/conda/envs/finlab/bin/python

COPY environments.yml .
RUN conda env create --name finlab -f environments.yml
RUN rm environments.yml

COPY requirements.txt .
RUN $PYTHON_PATH -m pip install -r requirements.txt
RUN rm requirements.txt
RUN $PYTHON_PATH -m pip install jupyterlab

COPY check.py .
RUN $PYTHON_PATH check.py

ENTRYPOINT ["/opt/conda/envs/finlab/bin/python", "-m", "jupyter", "lab", "--ip='*'", "--NotebookApp.token=''", "--NotebookApp.password=''", "--allow-root"]