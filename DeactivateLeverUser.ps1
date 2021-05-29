#Deactivate a Lever user  
function DeactivateLeverUser { 
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
	$uri = "https://api.lever.co/v1/users?email=" + $Email -Replace("@","%40") 
	$result = Invoke-RestMethod -Uri $uri -Headers $headers -Method GET 
	if(!$result){ 
	Write-Host "The user account does not exist!" -ForeGroundColor Red;Break 
	} else { 
	$json = [pscustomobject]@{} 
	$json = $json | ConvertTo-Json 
	$uri = "https://api.lever.co/v1/users/" + $result.data.id + "/deactivate" 
	Invoke-RestMethod -Uri $uri -Headers $headers -Method POST -Body $json 
	} 
} 
DeactivateLeverUser 
