function Get-MaestroConfig 
{
	# MaestroPanel Config
	$APIKey = "2_8715ab83026c437f961ad85a15899aa3"
	$BaseURL = "http://demo.maestropanel.net:9715/Api"
	
	$Config = New-Object Psobject
	$Config | Add-Member Noteproperty APIKey $APIKey
	$Config | Add-Member Noteproperty BaseUrl $BaseUrl
    Write-Output $Config
}

function New-MaestroDomain {

<#
    .SYNOPSIS
     
        Function to create new domain on MaestroPanel.
 
    .DESCRIPTION
     
        This function creates domains on MaestroPanel by using pre-configured domain plans.
		You can also enable domain user on that domain for administration purposes.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        New-MaestroDomain -Domain "domain.com" -Plan "GoldPlan" -Username "domain.com" -Password "PassW0Rd!"
        Creates new domain on MaestroPanel called "domain.com" by using "GoldPlan" domain plan.
		
    .EXAMPLE
     
        New-MaestroDomain -Domain "domain.com" -Plan "GoldPlan" -Username "domain.com" -Password "PassW0Rd!" -EnableUser -FirstName "John" -LastName "Doe" -Mail "jd@mail.com"
        Creates new domain on MaestroPanel called "domain.com" and enables domain user called "John Doe".
		
    .INPUTS
         
        Domain name, Plan name and User informations.
 
    .OUTPUTS
 
        Result Message.
	
    .NOTES
         
        Author: Yusuf Ozturk
        Website: http://www.yusufozturk.info
        Email: ysfozy[at]gmail.com
        Date created: 03-May-2011
        Last modified: 14-Feb-2012
        Version: 1.0
 
    .LINK
        
        http://www.maestropanel.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Domain name')]
    [string]$Domain,
	
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Plan name')]
    [string]$Plan,
	
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'User name')]
    [string]$Username,
	
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Password')]
    [string]$Password,
		
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Enable domain user')]
    [switch]$EnableUser = $false,

    [Parameter(
        Mandatory = $false,
        HelpMessage = 'First name of user')]
    [string]$FirstName,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Last name of user')]
    [string]$LastName,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Mail address of user')]
    [string]$Mail,
	
    [Parameter(
        Mandatory = $false,
        HelpMessage = 'Base URL address')]
    [string]$BaseURL,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'API Key')]
    [string]$APIKey
)

begin {

	# Get MaestroPanel Config
	$Config = Get-MaestroConfig
	
	if (!$BaseURL)
	{
		$BaseURL = $Config.BaseURL	
	}
	
	if (!$APIKey)
	{
		$APIKey = $Config.APIKey
	}
	
	# Validate Parameters
	$Domain = $Domain.Replace(" ","")
	$Plan = $Plan.Replace(" ","")
	$Username = $Username.Replace(" ","")
	$Password = $Password.Replace(" ","")
	$FirstName = $FirstName.Replace(" ","")
	$LastName = $LastName.Replace(" ","")
	$Mail = $Mail.Replace(" ","")
}

process {

	# Generate Parameters
	$Parameters = "name=" + $Domain + "&planAlias=" + $Plan + "&username=" + $Username + "&password=" + $Password
	
	if ($EnableUser -eq $true)
	{
		$Parameters = $Parameters + "&activedomainuser=true"
		if ($FirstName) { $Parameters = $Parameters + "&firstname=" + $FirstName }
		if ($LastName) { $Parameters = $Parameters + "&lastname=" + $LastName }
		if ($Mail) { $Parameters = $Parameters + "&email=" + $Mail }
	}

	# Invoke Command with Parameters
	$Results = Invoke-MaestroCMD -Zone "Domain" -Action "Create" -BaseURL $BaseURL -Parameters $Parameters
	$Results
}
 
end {

	Write-Debug "Done"
}
} # End of function New-MaestroDomain

function Remove-MaestroDomain {

<#
    .SYNOPSIS
     
        Function to remove domain on MaestroPanel.
 
    .DESCRIPTION
     
        This function removes domains on MaestroPanel.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Remove-MaestroDomain -Domain "domain.com"
        Removes domain called "domain.com" on MaestroPanel.
		
    .INPUTS
         
        Domain name.
 
    .OUTPUTS
 
        Result Message.
	
    .NOTES
         
        Author: Yusuf Ozturk
        Website: http://www.yusufozturk.info
        Email: ysfozy[at]gmail.com
        Date created: 03-May-2011
        Last modified: 14-Feb-2012
        Version: 1.0
 
    .LINK
        
        http://www.maestropanel.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Domain name')]
    [string]$Domain,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Base URL address')]
    [string]$BaseURL,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'API Key')]
    [string]$APIKey
)

begin {

	# Get MaestroPanel Config
	$Config = Get-MaestroConfig
	
	if (!$BaseURL)
	{
		$BaseURL = $Config.BaseURL	
	}
	
	if (!$APIKey)
	{
		$APIKey = $Config.APIKey
	}
	
	# Validate Parameters
	$Domain = $Domain.Replace(" ","")
}

process {

	# Generate Parameters
	$Parameters = "name=" + $Domain
	
	# Invoke Command with Parameters
	$Results = Invoke-MaestroCMD -Zone "Domain" -Action "Delete" -BaseURL $BaseURL -APIKey $APIKey -Parameters $Parameters
}
 
end {

	Write-Debug "Done"
}
} # End of function Remove-MaestroDomain

function Stop-MaestroDomain {

<#
    .SYNOPSIS
     
        Function to stop domain on MaestroPanel.
 
    .DESCRIPTION
     
        This function stops domains on MaestroPanel.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Stop-MaestroDomain -Domain "domain.com"
        Stops domain called "domain.com" on MaestroPanel.
		
    .INPUTS
         
        Domain name.
 
    .OUTPUTS
 
        Result Message.
	
    .NOTES
         
        Author: Yusuf Ozturk
        Website: http://www.yusufozturk.info
        Email: ysfozy[at]gmail.com
        Date created: 03-May-2011
        Last modified: 14-Feb-2012
        Version: 1.0
 
    .LINK
        
        http://www.maestropanel.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Domain name')]
    [string]$Domain,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Base URL address')]
    [string]$BaseURL,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'API Key')]
    [string]$APIKey
)

begin {

	# Get MaestroPanel Config
	$Config = Get-MaestroConfig
	
	if (!$BaseURL)
	{
		$BaseURL = $Config.BaseURL	
	}
	
	if (!$APIKey)
	{
		$APIKey = $Config.APIKey
	}
	
	# Validate Parameters
	$Domain = $Domain.Replace(" ","")
}

process {

	# Generate Parameters
	$Parameters = "name=" + $Domain
	
	# Invoke Command with Parameters
	$Results = Invoke-MaestroCMD -Zone "Domain" -Action "Stop" -BaseURL $BaseURL -APIKey $APIKey -Parameters $Parameters
}
 
end {

	Write-Debug "Done"
}
} # End of function Stop-MaestroDomain

function Start-MaestroDomain {

<#
    .SYNOPSIS
     
        Function to start domain on MaestroPanel.
 
    .DESCRIPTION
     
        This function starts domains on MaestroPanel.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Start-MaestroDomain -Domain "domain.com"
        Starts domain called "domain.com" on MaestroPanel.
		
    .INPUTS
         
        Domain name.
 
    .OUTPUTS
 
        Result Message.
	
    .NOTES
         
        Author: Yusuf Ozturk
        Website: http://www.yusufozturk.info
        Email: ysfozy[at]gmail.com
        Date created: 03-May-2011
        Last modified: 14-Feb-2012
        Version: 1.0
 
    .LINK
        
        http://www.maestropanel.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Domain name')]
    [string]$Domain,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Base URL address')]
    [string]$BaseURL,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'API Key')]
    [string]$APIKey
)

begin {

	# Get MaestroPanel Config
	$Config = Get-MaestroConfig
	
	if (!$BaseURL)
	{
		$BaseURL = $Config.BaseURL	
	}
	
	if (!$APIKey)
	{
		$APIKey = $Config.APIKey
	}
	
	# Validate Parameters
	$Domain = $Domain.Replace(" ","")
}

process {

	# Generate Parameters
	$Parameters = "name=" + $Domain
	
	# Invoke Command with Parameters
	$Results = Invoke-MaestroCMD -Zone "Domain" -Action "Start" -BaseURL $BaseURL -APIKey $APIKey -Parameters $Parameters
}
 
end {

	Write-Debug "Done"
}
} # End of function Start-MaestroDomain

function Set-MaestroPassword {

<#
    .SYNOPSIS
     
        Function to set new password on MaestroPanel.
 
    .DESCRIPTION
     
        This function sets a new password to domain user on MaestroPanel.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Set-MaestroPassword -Domain "domain.com" -NewPassword "p4ssw0rd"
        Sets new password to "domain.com" user on MaestroPanel.
		
    .INPUTS
         
        Domain name.
 
    .OUTPUTS
 
        Result Message.
	
    .NOTES
         
        Author: Yusuf Ozturk
        Website: http://www.yusufozturk.info
        Email: ysfozy[at]gmail.com
        Date created: 03-May-2011
        Last modified: 14-Feb-2012
        Version: 1.0
 
    .LINK
        
        http://www.maestropanel.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Domain name')]
    [string]$Domain,
	
	[Parameter(
        Mandatory = $true,
        HelpMessage = 'New password')]
    [string]$NewPassword,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Base URL address')]
    [string]$BaseURL,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'API Key')]
    [string]$APIKey
)

begin {

	# Get MaestroPanel Config
	$Config = Get-MaestroConfig
	
	if (!$BaseURL)
	{
		$BaseURL = $Config.BaseURL	
	}
	
	if (!$APIKey)
	{
		$APIKey = $Config.APIKey
	}
	
	# Validate Parameters
	$Domain = $Domain.Replace(" ","")
}

process {

	# Generate Parameters
	$Parameters = "name=" + $Domain + "&newpassword=" + $NewPassword
	
	# Invoke Command with Parameters
	$Results = Invoke-MaestroCMD -Zone "Domain" -Action "Password" -BaseURL $BaseURL -APIKey $APIKey -Parameters $Parameters
}
 
end {

	Write-Debug "Done"
}
} # End of function Set-MaestroPassword

function Invoke-MaestroCMD {

<#
    .SYNOPSIS
     
        Function to invokes commands on MaestroPanel.
 
    .DESCRIPTION
     
        This function invokes commands on MaestroPanel by using MaestroPanel API.
             
    .PARAMETER  WhatIf
     
        Display what would happen if you would run the function with given parameters.
    
    .PARAMETER  Confirm
     
        Prompts for confirmation for each operation. Allow user to specify Yes/No to all option to stop prompting.
    
    .EXAMPLE
     
        Invoke-MaestroCMD -Zone "Domain" -Action "Create" -Parameters "name=domain.com&planAlias=GOLDPLAN&username=domain.com&password=PassW0Rd!&activedomainuser=true"
        Invokes command without Base URL and API Key. It uses Get-MaestroConfig to get stored Base URL and API Key information.
		
    .EXAMPLE
     
        Invoke-MaestroCMD -Zone "Domain" -Action "Create" -BaseURL "http://demo.maestropanel.net:9715/Api" -APIKey "2_8715ab83026c437f961ad85a15899aa3" -Parameters "name=domain.com&planAlias=GoldPlan&username=domain.com&password=PassW0Rd!&activedomainuser=true"
        Invokes command with Base URL and API Key.
		
    .INPUTS
         
        Domain name, Plan name and User informations.
 
    .OUTPUTS
 
        None
	
    .NOTES
         
        Author: Yusuf Ozturk
        Website: http://www.yusufozturk.info
        Email: ysfozy[at]gmail.com
        Date created: 03-May-2011
        Last modified: 14-Feb-2012
        Version: 1.0
 
    .LINK
        
        http://www.maestropanel.com
		
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param (

    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Zone name')]
    [string]$Zone,
	
    [Parameter(
        Mandatory = $true,
        HelpMessage = 'Action name')]
    [string]$Action,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'Base URL address')]
    [string]$BaseURL,
	
	[Parameter(
        Mandatory = $false,
        HelpMessage = 'API Key')]
    [string]$APIKey,
	
	[Parameter(
        Mandatory = $true,
        HelpMessage = 'Parameters')]
    [string]$Parameters
)

begin {

	# Get MaestroPanel Config
	$Config = Get-MaestroConfig
	
	if (!$BaseURL)
	{
		$BaseURL = $Config.BaseURL	
	}
	
	if (!$APIKey)
	{
		$APIKey = $Config.APIKey
	}
}

process {

	# Generate API Url
	$APIURL = $BaseURL + "/" + $Zone + "/" + $Action

	# Generate Parameters
	$Parameters = "key=" + $APIKey + "&" + $Parameters
	
	# Post Data with Parameters
	$Request = New-Object -ComObject Msxml2.XMLHTTP
	$Request.open('POST', $APIURL, $false)
	$Request.setRequestHeader("Content-type", "application/x-www-form-urlencoded")
	$Request.setRequestHeader("Content-length", $Parameters.length)
	$Request.setRequestHeader("Connection", "close")
	$Request.send($Parameters)
	$Response = [xml]$Request.responseText
	$ResultCode = $Response.Result.Code
	$ResultMessage = $Response.Result.Message
	
	# Process Result Code
	if ($ResultCode -eq "0")
	{
		Write-Host $ResultMessage
	}
	else
	{
		Write-Error $ResultMessage
	}	
}
 
end {

	Write-Debug "Done"
}
} # End of function Invoke-MaestroCMD