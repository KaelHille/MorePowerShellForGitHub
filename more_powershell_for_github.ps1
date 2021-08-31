function Get-authHeader{
    param($Credential)

$auth = [System.Convert]::ToBase64String([char[]]$c.GetNetworkCredential().Password)
$headers = @{Authorization="Basic $auth"}

return $headers

}

function Add-GitHubCollaborator{
    param( $R,$C,$U,$authentification)

$User="KaelHille"

$api = 'https://api.github.com/repos/'+ $User + '/'+ $R + '/collaborators/'+ $U; 

Invoke-RestMethod  -Method PUT -Headers $C -uri $api
}

function Collaboration-invites{
    param($RepositoryName,$OwnerGroup,$MailDomains)

$api ="https://api.github.com/user/repository_invitations" 
$invitation = Invoke-RestMethod -Method Get $authentification -uri $api 

if($RepositoryName -ne $null)
    { 
        $RepositoryName  
    }
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

$authentification = Get-authHeader -Credential $C

$api ="https://api.github.com/user/repository_invitations" 
$invitation = Invoke-RestMethod -Method Get $authentification -uri $api

$invitation.repository

 



