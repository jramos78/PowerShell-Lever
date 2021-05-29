#Reactivate a Lever user  
function ReactivateLeverUser { 
	param( 
		[parameter(Mandatory)] 
		[string]$Email,
		[parameter(Mandatory)] 
		[string]$APIKey
	) 
	$password = "" 
	$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey,$password))) 
	#Set the API call header 
	[string]$contentType = "application/json"  
	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"  
	$headers.Add("Content-Type", $contentType)  
	$headers.Add("Authorization", "Basic $base64AuthInfo") 
	#Get all users, include inactive ones 
	$uri = "https://api.lever.co/v1/users?includeDeactivated=true" 
	$result = Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Basic $base64AuthInfo"} -Method GET 
	$users = $result.data 
	#Get the user's id 
	forEach ($i in $users){if ($i.email -eq $Email){$userId = $i.id}} 
	#Reactivate the user's account 
	if($userId){ 
		$json = [pscustomobject]@{} 
		$json = $json | ConvertTo-Json 
		$uri = "https://api.lever.co/v1/users/" + $userId + "/reactivate" 
		$result = Invoke-RestMethod -Uri $uri -Headers $headers -Method POST -Body $json 
		Write-Host "`nThe $Email user account has been reactivated!" -ForeGroundColor Cyan 
	} else {Write-Host "The user account does not exist!" -ForeGroundColor Red;Break} 
} 
ReactivateLeverUser
