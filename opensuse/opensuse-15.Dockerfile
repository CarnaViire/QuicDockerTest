FROM opensuse/leap:15

RUN zypper ref && \
    zypper install -y \
        libicu-devel \
        curl \
        tar \
        gzip \
        vim

COPY  microsoft.asc /tmp
RUN zypper addrepo https://packages.microsoft.com/opensuse/15/prod/ "MS Packages" && \
    rpm --import /tmp/microsoft.asc && \
    rm /tmp/microsoft.asc

RUN zypper install -y libmsquic && \
    zypper clean -a

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --quality daily --install-dir /usr/share/dotnet 

COPY ./MsQuicTest MsQuicTest
RUN /usr/share/dotnet/dotnet build -c release ./MsQuicTest

COPY ./runtest.sh .
RUN chmod u+x ./runtest.sh

CMD ./runtest.sh