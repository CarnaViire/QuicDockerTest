$distros = `
    #("alpine", "3.15"), `
    #("alpine", "3.16"), `
    #("alpine", "3.17"), `
    #("alpine", "3.18"), `
    ("almalinux", "8"), `
    ("almalinux", "9"), `
    ("centos", "stream8"), `
    ("centos", "stream9"), `
    ("debian", "10"), `
    ("debian", "11"), `
    ("debian", "12"), `
    ("fedora", "37-hack"), `
    ("fedora", "38"), `
    ("opensuse", "15"), `
    ("ubuntu", "20.04"), `
    ("ubuntu", "22.04"), `
    ("ubuntu", "23.04")

function Test-Execute {
    param (
        [Parameter(Mandatory)]
        [string]$Command,
        [string[]]$Parameters
    )

    $Expr = $Command

    foreach ($Parameter in $Parameters) {
        $Expr += " " + $Parameter
    }

    write-host $Expr -ForegroundColor blue
    Invoke-Expression $Expr
}

foreach ($distrosEntry in $distros) {
    $distro = $distrosEntry[0]
    $version = $distrosEntry[1]

    # docker build -t alpine-3.17-quic -f .\alpine\alpine-3.17.Dockerfile --quiet .
    # docker build -t debian-12-quic -f .\debian\debian-12.Dockerfile .
    # docker build -t fedora-37-quic -f .\fedora\fedora-37.Dockerfile .
    Test-Execute -Command "docker build" -Parameters "-t $distro-$version-quic", "-f .\$distro\$distro-$version.Dockerfile", "--quiet", "."
}

write-host "`n"

foreach ($distrosEntry in $distros) {
    $distro = $distrosEntry[0]
    $version = $distrosEntry[1]

    # docker run -it --rm alpine-3.17-quic
    # docker run -it --rm debian-12-quic
    Test-Execute -Command "docker run -it --rm" -Parameters "$distro-$version-quic"
    write-host "`n"
}