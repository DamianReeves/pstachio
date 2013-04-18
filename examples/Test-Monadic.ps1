param(
    [Parameter(Position=0,Mandatory=0)]
    [string]$scriptPath= $($MyInvocation.MyCommand.Path)
)

if (-not($scriptPath)) {
    $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.path)
}

Remove-Module monadic -ErrorAction SilentlyContinue
Import-Module (Join-Path $scriptPath "..\monadic.psm1")

function Test-NewParser {
    $intParser = New-Parser integer

    $members = $intParser | Get-Member
    $members
}

function Test-ParseInt {
    $numberParser = parser integer {
        param ($input=$null)
        write-host $input
        $input
    }    

    $numberParser | parse "12345" 
}

try {
    Push-Location
    Set-Location $scriptPath

    Test-NewParser
    Test-ParseInt
} finally { 
    Pop-Location
}