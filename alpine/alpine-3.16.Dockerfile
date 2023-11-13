FROM alpine:3.16

RUN apk update && apk add --no-cache \
    bash \
    coreutils \
    curl \
    icu-data \
    icu-libs \
    iputils \
    lldb \
    lttng-ust \
    musl-locales \
    openssl \
    python3 \
    sudo \
    tzdata

# build MsQuic as we don't have Alpine packages (yet)
RUN apk update && apk add --no-cache && \
    apk add \
        cmake \
        g++ \
        gcc \
        git \
        numactl-dev \
        linux-headers \
        lttng-ust-dev \
        make \
        musl-dev \
        openssl-dev \
        perl && \
    cd /tmp && \
    git clone --depth 1 --single-branch --branch main --recursive https://github.com/dotnet/msquic && \
    cd msquic/src/msquic && \
    cmake -B build/linux/x64_openssl \
       -DQUIC_OUTPUT_DIR=/tmp/msquic/src/msquic/artifacts/bin/linux/x64_Release_openssl \
       -DCMAKE_BUILD_TYPE=Release \
       -DQUIC_TLS=openssl \
       -DQUIC_ENABLE_LOGGING=true \
       -DQUIC_USE_SYSTEM_LIBCRYPTO=true \
       -DQUIC_BUILD_TOOLS=off \
       -DQUIC_BUILD_TEST=off \
       -DQUIC_BUILD_PERF=off && \
    cmake --build build/linux/x64_openssl  --config Release && \
    cp artifacts/bin/linux/x64_Release_openssl/libmsquic.so.* artifacts/bin/linux/x64_Release_openssl/libmsquic.lttng.so.* /usr/lib && \
    rm -rf /tmp/msquic && \
    apk del \
        cmake \
        g++ \
        gcc \
        git \
        linux-headers \
        lttng-ust-dev \
        make \
        musl-dev \
        openssl-dev \
        perl

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

COPY ./runtest.sh .
RUN chmod u+x ./runtest.sh

CMD ./runtest.sh