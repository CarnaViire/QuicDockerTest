FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
        curl \
        gnupg \
        libicu-dev \
        software-properties-common \
        vim

COPY  microsoft.asc /tmp
RUN apt-key add /tmp/microsoft.asc && \
    apt-add-repository https://packages.microsoft.com/debian/12/prod && \
    rm /tmp/microsoft.asc

# 2.046 E: Unable to locate package libmsquic
RUN apt-get update && \
    apt-get install -y libmsquic && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

CMD /usr/share/dotnet/dotnet run -c release --project ./MsQuicTest/MsQuicTest.csproj