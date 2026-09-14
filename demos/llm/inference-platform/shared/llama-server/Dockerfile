FROM nvidia/cuda:12.8.1-devel-ubuntu22.04 AS build
ARG FORK_COMMIT
RUN apt-get update && apt-get install -y --no-install-recommends \
      git cmake build-essential ca-certificates \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /src
RUN git clone https://github.com/PrismML-Eng/llama.cpp.git . \
 && git checkout "$FORK_COMMIT"
RUN cmake -B build -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release \
 && cmake --build build --target llama-server -j"$(nproc)"

FROM nvidia/cuda:12.8.1-runtime-ubuntu22.04
COPY --from=build /src/build/bin/llama-server /usr/local/bin/llama-server
EXPOSE 8080
ENTRYPOINT ["llama-server"]
