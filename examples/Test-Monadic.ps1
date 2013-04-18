param(
    [Parameter(Position=0,Mandatory=0)]
    [string]$scriptPath= $($MyInvocation.MyCommand.Path)
)

if (-not($scriptPath)) {
    $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.path)
}

Remove-Module monadic -ErrorAction SilentlyContinue
Import-Module (Join-Path $scriptPath "..\monadic.psm1")

function Test-ParseInt {
    $inputStr = "12345"

}

try {
    Push-Location
    Set-Location $scriptPath
} finally { 
    Pop-Location
}