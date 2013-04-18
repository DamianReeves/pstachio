pstachio
========

A PowerShell based mustache template processor and parsec implementation

monadic
========
Monadic aims to be an implementation of a monadic parser in PowerShell

Target Syntax is something like:

**Create Parser:**

    $integerParser = parser integer {
        param($input = $null, $context = $null)
        switch ($input.Text){
            {
                $intValue = 0
                [Int32]::TryParse($_, out $intValue)
            }

            default {
                #Raise An Error or return a default
                $context.Value
            }
        }
    }

**Parse:**

    $integerParser | "12345"   
    
