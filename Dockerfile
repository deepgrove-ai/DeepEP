ARG BASE_IMAGE=nvcr.io/nvidia/nemo:25.09
FROM ${BASE_IMAGE} AS base  
RUN uv self update

ARG INSTALL_DEEPEP=True
ARG DEEPEP_COMMIT=92fe2deaec24bc92ebd9de276daa6ca9ed602ed4

RUN if [ "$INSTALL_DEEPEP" = "True" ]; then \
  git clone https://github.com/deepseek-ai/DeepEP.git && \
  cd DeepEP && \
  git pull && \
  git fetch origin $DEEPEP_COMMIT && \
  git checkout FETCH_HEAD && \
  # patch -p1 < /opt/deepep.patch && \
  uv pip install --no-cache-dir nvidia-nvshmem-cu12 && \
  TORCH_CUDA_ARCH_LIST="9.0a" uv pip install --no-cache-dir --no-build-isolation -v . && \
  rm -rf /opt/deepep.patch && \
  rm -rf DeepEP; \
  fi

RUN uv pip install git+https://github.com/fanshiqing/grouped_gemm@v1.1.4 --no-build-isolation
