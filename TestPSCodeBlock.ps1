#Requires -modules PSScriptAnalyzer

function Test-PSCodeBlock {
    param (
        $markdownFile = "$pwd\README.md",
        $outputPath = $pwd,
        [Switch]$KeepLintFile
    )

    $codeBlocks = [ordered]@{}
    $inCodeBlock = $false
    $codeBlockIndex = 0
    $excludeCode = $false

    if (!(Test-IsUri $markdownFile)) {
        $markdownContent = Get-Content $markdownFile
    }
    else {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $markdownContent = Invoke-RestMethod $markdownFile
        $markdownContent = $markdownContent -split "`n"
    }

    # switch -File ($markdownFile) {
    switch ($markdownContent) {

        '<!-- EXCLUDE CODE START -->' {$excludeCode = $true}
        '<!-- EXCLUDE CODE END -->' {$excludeCode = $false}

        '```' {
            $inCodeBlock = $false
            $codeBlockIndex += 1
        }

        {$inCodeBlock} {
            if (!$excludeCode) {
                $currentBlock = "block{0:0#}" -f $codeBlockIndex
                $codeBlocks.$currentBlock += $_ + "`r`n"
            }
        }

        '```ps' {$inCodeBlock = $true}

        default {}
    }

    if ($codeBlocks.Values.count -gt 0) {
        #$targetFile = "$pwd\lintThis.ps1"
        $targetFile = "$outputPath\lintThis.ps1"
        $codeBlocks.Values | Set-Content -Encoding Ascii $targetFile

        try {
            $analysis = Invoke-ScriptAnalyzer $targetFile -ErrorAction Stop

            if ($analysis.count -gt 0) {
                $analysis
            }
            else {
                "all analyzed - no issues"
                if (!$KeepLintFile) {
                    Remove-Item $targetFile
                }
            }
        }
        catch {
            $_.Exception
            #throw 'caught'
        }
    }
    else {
        "no code found"
    }
}