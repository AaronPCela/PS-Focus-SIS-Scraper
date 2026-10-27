

function Expand-StudentData {
    param (
        [Parameter(Mandatory)]
        $WebContent
    )

    $WebContent = $WebContent -split '\r?\n'

    $Prefix = 'const controllers = Module.init('

    foreach ($Line in $WebContent) {
        if ($Line -like '*"FocusModule\\*') {
            $Data = $Line.TrimStart().Substring($Prefix.Length).TrimEnd("`r", "`n", " ", ";", ")") | ConvertFrom-Json -AsHashtable
            
            foreach ($key in $Data.Keys) {
                if ($Data[$key].ContainsKey('PortalController')) {
                    return $Data[$key]['PortalController']
                }
            }
        }
    }


}

