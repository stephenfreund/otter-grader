# Dockerfile forked from https://github.com/jeffheaton/docker-jupyter-python-r/blob/master/Dockerfile
FROM ubuntu:20.10

# common packages
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y tzdata git vim wget libssl-dev nano && \
    rm -rf /var/lib/apt/lists/*

# miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' >> /root/.bashrc && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:$PATH

# R pre-reqs
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends fonts-dejavu gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# R
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y r-base && \
    conda install -c r r-irkernel r-essentials -c conda-forge && \
    rm -rf /var/lib/apt/lists/*

# pandoc, xetex for otter export
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y pandoc && \
    apt-get install -y texlive-xetex texlive-fonts-recommended

# install wkhtmltopdf for otter export
RUN wget --quiet -O /tmp/wkhtmltopdf.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb && \
    apt-get install -y /tmp/wkhtmltopdf.deb

# Postgres
RUN apt-get clean && \
    apt-get update && \
    apt-get install -y postgresql postgresql-client libpq-dev

# Python requirements
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN pip install git+https://github.com/ucbds-infra/otter-grader.git@cecbb5752f4b23621da7054843335af5c357d721
