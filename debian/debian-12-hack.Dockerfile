FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg \
        libicu-dev \
        software-properties-common \
        vim

# !HACK! - msquic package for Debian 12 is not available yet; we need a package with OpenSSL 3
RUN curl -LO https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/libm/libmsquic/libmsquic_2.2.2_amd64.deb && \
    dpkg -i libmsquic_*.deb && \
    rm -f libmsquic_*.deb

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

COPY ./runtest.sh .
RUN chmod u+x ./runtest.sh

CMD ./runtest.sh