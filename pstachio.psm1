                                           
function Get-VariableName {
    param($text, 
    [string]$startDelimiter = "{{", 
    [string]$endDelimiter = "}}"
    )

    $text -replace $startDelimiter, '' -replace $endDelimiter, ''
}

function Parse-Template ([string]$t, [string]$startDelimiter, [string]$endDelimiter){

    $StartLocation = $t.IndexOf('{{')    

    while($StartLocation -gt -1) {
        
        $EndLocation = $t.IndexOf('}}', $StartLocation) + 2
        $Length = $EndLocation-$StartLocation
        $Text = $t.Substring($StartLocation, $EndLocation-$StartLocation)
        
        Switch ($Text) {
            
            {$_.StartsWith('{{#')}{
                $TokenType="Start"
                $variable =  (Get-VariableName $text) -replace '#', '$Context.'
                $Transform = "foreach(`$item in $variable) {"
                $InBlock = $true
            }

            {$_.StartsWith('{{/')}{
                $TokenType="End"
                $Transform = '}'
                $InBlock = $false
            }
            
            default {
                $TokenType="String"
                $variable =  Get-VariableName $text
                if($InBlock) {
                    $Transform = "`$(`$item.$variable)"
                } else {
                    $Transform = "`$(`$Context.$variable)"
                }
            }
        }

        [PSCustomObject]@{
            StartLocation=$StartLocation
            EndLocation=$EndLocation
            Length=$Length
            Text=$Text
            TokenType=$TokenType
            Transform=$Transform
        }

        $StartLocation = $t.IndexOf('{{', $StartLocation+1)
    }

}

function Invoke-Template (){
    param(
        [Parameter(Position=0, Mandatory=1)][String]$template,
        [Parameter(Position=1, Mandatory=0)]$Context,
        [Parameter(Position=2, Mandatory=$false)][String]$StartDelimiter="{{",
        [Parameter(Position=3, Mandatory=$false)][String]$EndDelimiter="{{"
    )
    $Context = $Context | ConvertFrom-Json
    $tokens = Parse-Template $Template $StartDelimiter $EndDelimiter

    $stringBuilder=@()
    $outString=@()
    foreach($token in $tokens) {
    
        switch ($token.TokenType) {
            'start' {
                $stringBuilder+=$token.Transform
                $PreviousEndLocation = $token.EndLocation
            }

            'end' {

                if($PreviousEndLocation -ne $token.StartLocation) {
                    $outString+=$Template.Substring($PreviousEndLocation, $token.StartLocation-$PreviousEndLocation)
                }
                
                if($outString.Count -gt 0) {
                    $outString = '"' + ($outString -join '') + '"'
                }
                
                $stringBuilder+=$outString
                $stringBuilder+=$token.Transform
            }

            'string' {
                if($PreviousEndLocation -ne $token.StartLocation) {
                    $outString+=$Template.Substring($PreviousEndLocation, $token.StartLocation-$PreviousEndLocation)
                }
                $outString+=$token.Transform
                $PreviousEndLocation = $token.EndLocation
            }
        }
    }
    
    $stringBuilder -join "`r`n" | Invoke-Expression
}

Export-ModuleMember -Function Invoke-Template