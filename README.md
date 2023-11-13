# Quic Docker Test

To run the test for all distros:
```pwsh
.\quic-docker.ps1
```

To run the test for a specific distro (e.g. Debian 12):

```pwsh
docker build -t debian-12-quic -f .\debian\debian-12.Dockerfile .
docker run -it --rm debian-12-quic
```
