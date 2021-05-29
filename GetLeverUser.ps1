function GetLeverUser { 
  param( 
    [parameter(Mandatory)] 
    [string]$Email,
    parameter(Mandatory)] 
    [string]$APIKey
  )
  $password = "" 
  $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey,$password))) 
  $uri = "https://api.lever.co/v1/users?email=" + $Email -Replace("@","%40") 
  $result = Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Basic $base64AuthInfo"} -Method GET 
  $result.data 
} 
GetLeverUser
