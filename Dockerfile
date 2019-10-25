FROM nfcore/base:1.7
LABEL authors="Li Chenhao" \
      description="Docker image containing all requirements for nf-core/shotgunmetagenomics pipeline"

COPY environment.yml /
RUN conda env create -f /environment.yml && conda clean -a
ENV PATH /opt/conda/envs/nf-core-shotgunmetagenomics-0.0.1dev/bin:$PATH
