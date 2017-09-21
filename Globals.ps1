#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------
[int]$global:TotalResults = 0
$global:CopyToAdmin = $false
$global:TestStatus = $false
$global:DiscoveredObjects = @()
[string]$global:SearchQuery = ""
$global:DateTime = Get-Date -Format yyyy-MM-dd_HHmm
[string]$global:LogDir = "$env:USERPROFILE\Desktop\DeletedMessages_$DateTime.log"

#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

function Get-MailboxSearchQuery
{
	param
	(
		[parameter(Mandatory = $false)]
		$To,
		[parameter(Mandatory = $false)]
		$From,
		[parameter(Mandatory = $false)]
		$Subject,
		[parameter(Mandatory = $false)]
		$DateSent
	)
	$SearchQuery = "`'"
	if ($To -ne "" -and $To -ne $null)
	{
		if ($SearchQuery -ne "`'"){ $SearchQuery += " "}
		$SearchQuery += "To: `"$to`""
	}
	if ($From -ne "" -and $From -ne $null)
	{
		if ($SearchQuery -ne "`'") { $SearchQuery += " " }
		$SearchQuery += "From: `"$From`""
	}
	if ($Subject -ne "" -and $Subject -ne $null)
	{
		if ($SearchQuery -ne "`'") { $SearchQuery += " " }
		$SearchQuery += "Subject: `"$Subject`""
	}
	if (($DateSent -ne "" -and $DateSent -ne $null))
	{
		if ($SearchQuery -ne "`'") { $SearchQuery += " " }
		$SearchQuery += "Sent: `"$DateSent`""
	}
	$SearchQuery += "`'"
	
	$SearchQuery
}

function Get-MailboxSearchTest
{
	param
	(
		[parameter(Mandatory = $true)][string]$SearchQuery
	)
	$SearchResults = Get-Mailbox -ResultSize unlimited | Search-Mailbox -SearchQuery $SearchQuery -EstimateResultOnly

	$SearchResults
}
