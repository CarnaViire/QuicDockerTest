FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg \
        libicu-dev \
        software-properties-common \
        vim

RUN apt-get install -y \
    libnuma-dev

RUN curl -LO https://packages.microsoft.com/ubuntu/20.04/prod/pool/main/libm/libmsquic/libmsquic_2.2.2_amd64.deb && \
    dpkg -i libmsquic_*.deb && \
    rm -f libmsquic_*.deb

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

COPY ./runtest.sh .
RUN chmod u+x ./runtest.sh

CMD ./runtest.sh