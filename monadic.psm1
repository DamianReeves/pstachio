function Parse {
    [CmdletBinding()]
    param (        
        [Parameter(Position=0,Mandatory=1)][PSCustomObject]$parser = $null,
        [Parameter(Position=1,Mandatory=1)][string]$text = $null
    )

    #TODO: Call $parser.Parse $text, but how????
    #$parser $text
}

function Parser {
    [CmdletBinding()]
    param (        
        [Parameter(Position=0,Mandatory=1)][string]$name = $null,
        [Parameter(Position=1,Mandatory=0)][scriptblock]$action = $null
    )
    $theParser = New-Parser $name $action
    Write-host $name
    $action
}

function New-Parser {
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][string]$name = $null,
        [Parameter(Position=1,Mandatory=0)][scriptblock]$action = $null
    )
    
    $obj = New-Object PSObject -Property @{
        Name = $name
        StartLocation=0
        EndLocation=0
        Length=0
        Text=$null
        TokenType=$null
        Parse = $action
    }

    if(-not ($action)) {
        $obj.Parse = { 
            param(
                [string]$text = $null
            )
            $obj 
        }
    }

    $obj
}



Export-ModuleMember -Function New-Parser, Parser, Parse