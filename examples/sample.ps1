param(
    [Parameter(Position=0,Mandatory=0)]
    [string]$scriptPath= $($MyInvocation.MyCommand.Path)
)

try {

    if (-not($scriptPath)) {
        $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.path)
    }
    Push-Location

    Set-Location $scriptPath

    #$template = (Get-Content .\fields.html.mustache)

    #$csv = Import-Csv .\data.csv  #-Header @("Index";"Ref";"Data Field";"Cell Format")
    #$csv
    #$json = ConvertTo-Json $csv
    #$json
    $data = (Get-Content .\people.json)

    $data
    $json = $data #| ConvertFrom-Json    
    Remove-Module pstachio -ErrorAction SilentlyContinue
    Import-Module (Join-Path $scriptPath "..\pstachio.psm1")

    $template = '<ul>{{#people}}<li>{{lastName}}, {{firstName}} <strong>{{Age}}</strong></li>{{/people}}</ul>'
    Invoke-Template $template.ToString() $json
} finally { 
    Pop-Location
}