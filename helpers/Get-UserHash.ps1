
function Get-UserHash {
    [CmdletBinding()]
    param(
        [String]$Username
    )
    
    $CleanUser = $Username.Trim().ToLower()
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($CleanUser)
    
    $Md5 = [System.Security.Cryptography.MD5]::Create()
    $HashBytes = $Md5.ComputeHash($Bytes)
    
    $ShortHash = ($HashBytes[0..3] | ForEach-Object { $_.ToString("x2") }) -join ""
    
    return "user_$ShortHash.xml"
}

