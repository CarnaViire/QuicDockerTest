FROM fedora:37

RUN dnf install -y \
        dnf-plugins-core \
        libicu \
        vim

COPY  microsoft.asc /tmp
RUN dnf config-manager --add-repo https://packages.microsoft.com/fedora/37/prod/ && \
    rpm --import /tmp/microsoft.asc && \
    rm /tmp/microsoft.asc

RUN dnf install -y \
        numactl-libs \
        libmsquic && \
    dnf clean all

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

# 14:35:07.9600912[Info] thisOrContextObject: (null), memberName: .cctor, message: Unable to load MsQuic library version '2'.
CMD /usr/share/dotnet/dotnet run -c release --project ./MsQuicTest/MsQuicTest.csproj