#Create a new Lever user based on data from Active Directory
function NewLeverUser { 
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
	#Get the user's name from Active Directory 
	$name = (Get-AdUser -filter {UserPrincipalName -eq $Email}).Name 
	#Check if the user already has an account and create it if they don't 
	$uri = "https://api.lever.co/v1/users?email=" + $Email -Replace("@","%40") 
	$result = Invoke-RestMethod -Uri $uri -Headers $headers -Method GET 
	if($result){ 
	Write-Host "$name already has a lever account!" -ForeGroundColor Red 
	} else { 
		$json = [pscustomobject]@{ 
		name = $name   
		email = $Email 
		accessRole = "team member" 
	} 
	$json = $json | ConvertTo-Json 
	$uri = "https://api.lever.co/v1/users" 
	Invoke-RestMethod -Uri $uri -Headers $headers -Method POST -Body $json 
	} 
} 
NewLeverUser
