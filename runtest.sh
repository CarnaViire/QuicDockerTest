#!/bin/bash

quicpath=$(find / -name libmsquic.so* | grep "/.*/libmsquic\.so\.[0-9]*$")
quicldd=$(ldd $quicpath)

echo $quicldd | grep -o "/\S*/libcrypto\.so\.\S*"
echo $quicldd | grep -i 'not found'

cd MsQuicTest
/usr/share/dotnet/dotnet run -c release