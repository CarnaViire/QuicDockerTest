FROM quay.io/centos/centos:stream8

RUN dnf install -y \
        dnf-plugins-core \
        libicu \
        vim

COPY  microsoft.asc /tmp
RUN dnf config-manager --add-repo https://packages.microsoft.com/centos/8/prod/ && \
    rpm --import /tmp/microsoft.asc && \
    rm /tmp/microsoft.asc

RUN dnf install -y libmsquic && \
    dnf clean all

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

COPY ./runtest.sh .
RUN chmod u+x ./runtest.sh

CMD ./runtest.sh