$PSVersionTable.PSVersion

$ErrorActionPreference = "Continue"

if ((Get-Module -ListAvailable pester) -eq $null) {
    Install-Module -Name Pester -Repository PSGallery -Force -Scope CurrentUser
}

if ((Get-Module -ListAvailable PSScriptAnalyzer) -eq $null) {
    Install-Module -Name PSScriptAnalyzer -Repository PSGallery -Force -Scope CurrentUser
}

$result = Invoke-Pester -Script $PSScriptRoot\__tests__ -Verbose -PassThru

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}