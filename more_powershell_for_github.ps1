function Get-authHeader{
    param($Credential)

$auth = [System.Convert]::ToBase64String([char[]]$c.GetNetworkCredential().Password)
$headers = @{Authorization="Basic $auth"}

return $headers

}

$username = 'KaelHille'

Read-Host -AsSecureString -Prompt ’token’ |
ConvertFrom-SecureString |
Tee-Object .\secret.txt |
ConvertTo-SecureString |
Set-Variable ss_token
$C = New-Object pscredential $username, $ss_token

Set-GitHubAuthentication -SessionOnly `
-Credential $C

$repo = "MorePowerShellForGitHub"


















