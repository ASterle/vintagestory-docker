# ============== download stage ==================
FROM alpine:latest AS downloader

WORKDIR /download

ARG VS_TYPE=stable
ARG VS_OS=linux-x64
ARG VS_VERSION=1.21.6

RUN apk update
RUN apk add wget tar

RUN wget "https://cdn.vintagestory.at/gamefiles/${VS_TYPE}/vs_server_${VS_OS}_${VS_VERSION}.tar.gz"
RUN tar -xvzf "vs_server_${VS_OS}_${VS_VERSION}.tar.gz"
RUN rm "vs_server_${VS_OS}_${VS_VERSION}.tar.gz"

# ============== runtime stage ==================
FROM mcr.microsoft.com/dotnet/sdk:8.0 as runtime
WORKDIR /game
# Defaults
ENV VS_DATA_PATH=/gamedata/vs
COPY --from=downloader "./download/" "/game"

#  Expose ports
EXPOSE 42420

# see https://docs.docker.com/reference/build-checks/json-args-recommended/
SHELL [ "sh", "-c" ]
# Execution command
ENTRYPOINT dotnet VintagestoryServer.dll --dataPath $VS_DATA_PATH
