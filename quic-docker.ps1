$distros = ("almalinux", "8"), `
    ("almalinux", "9"), `
    ("centos", "stream8"), `
    ("centos", "stream9"), `
    ("debian", "10"), `
    ("debian", "11"), `
    ("debian", "12-hack"), `
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

    write-host $Expr
    Invoke-Expression $Expr
}

foreach ($distrosEntry in $distros) {
    $distro = $distrosEntry[0]
    $version = $distrosEntry[1]

    Test-Execute -Command "docker build" -Parameters "-t $distro-$version-quic", "-f .\$distro\$distro-$version.Dockerfile", "--quiet", "."
}

write-host "`n"

foreach ($distrosEntry in $distros) {
    $distro = $distrosEntry[0]
    $version = $distrosEntry[1]

    Test-Execute -Command "docker run -it --rm" -Parameters "$distro-$version-quic"
    write-host "`n"
}