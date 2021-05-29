#List all Lever users (including inactive ones)  
function GetAllLeverUsers { 
	param( 
		[parameter(Mandatory)] 
		[string]$APIKey 
	) 
	$password = "" 
	$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey ,$password))) 
	$uri = "https://api.lever.co/v1/users?includeDeactivated=true" 
	$result = Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Basic $base64AuthInfo"} -Method GET 
	$result = $result.data 
	$result | Sort email | ft 
} 
GetAllLeverUsers 
