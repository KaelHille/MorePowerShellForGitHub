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

$nrinvites = $invitation.Count

if($RepositoryName -ne $null)
    {  
       for($nr=0;$nr -lt $nrinvites; $nr++)
       {
            if ($RepositoryName -eq $invitation.repository.name)
                {
                    Invoke-RestMethod -Method Patch -Headers $authentification -Uri 'https://api.github.com/user/repository_invitations/' + $invitation.id
                } 
        }
    }


if($OwnerGroup -ne $null)
    {
       $invitee = ($invitation | Select-Object -Property invitee).invitee.login
       $inviter = ($invitation | Select-Object -Property inviter).inviter.login

     for($nr=0;$nr -lt $nrinvites; $nr++)
        {

            $Bioveldinvitee = (Get-GitHubUser -UserName $invitee[$nr] | Select-Object -Property bio).bio
            $Bioveldinviter = (Get-GitHubUser -UserName $inviter[$nr] | Select-Object -Property bio).bio
        
            if($Bioveldinvitee -eq $Bioveldinviter)
                {
                    Invoke-RestMethod -Method Patch -Headers $authentification -Uri 'https://api.github.com/user/repository_invitations/' + $invitation[$nr].id
                }
        }
    }

if($MailDomains -ne $null)
    {
        $inviter = ($invitation | Select-Object -Property inviter).inviter.login 

        for($nr=0;$nr -lt $nrinvites; $nr++)
            {
                $email = (Get-GitHubUser -UserName $inviter[$nr] | Select-Object -Property email).email

                $domain = $email -match "ap.be"
                
                if($domain -eq $True)
                    {
                        Invoke-RestMethod -Method Patch -Headers $authentification -Uri 'https://api.github.com/user/repository_invitations/' + $invitation[$nr].id
                    }
            }
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








 



