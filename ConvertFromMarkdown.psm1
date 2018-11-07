. $PSScriptRoot\exportManuscript.ps1
. $PSScriptRoot\TestPSCodeBlock.ps1

function Test-Chapter {
    param (
        $outputPath = $pwd
    )

    (Get-ChildItem $outputPath).Count -gt 0
}

function ConvertFrom-Markdown {
    param (
        $markdownFile = "$pwd\README.md",
        $outputPath = $pwd,
        [ValidateSet("Html", "Docx", "PDF")]
        $OutputType,
        [Switch]$Show
    )

    Write-Progress -Activity "Generating manuscript" -Status "[$(Get-Date)] Creating chapters"
    Export-Manuscript -markdownFile $markdownFile -outputPath $outputPath

    $targetPath = "$($outputPath)\manuscript"

    Write-Progress -Activity "Generating manuscript" -Status "[$(Get-Date)] Analyzing PowerShell"
    Test-PSCodeBlock -markdownFile $markdownFile -outputPath $outputPath


    if (!(Test-Chapter $targetPath)) {
        "No chapters found"
        return
    }

    #if ((Get-Command pandoc.exe -ErrorAction SilentlyContinue) -and $AsPDF) {
    if ($OutputType) {

        if (!(Get-Command pandoc.exe -ErrorAction SilentlyContinue)) {
            Write-Warning @"
To generate that output type, you need to install Pandoc, https://pandoc.org/installing.html
If you want a PDF, you need to also install LaTeX, https://miktex.org/
"@
            return
        }

        # $chapters = (Get-Content "$targetPath\book.txt") -join ' '
        $chapters = (Get-ChildItem $targetPath chap* | ForEach-Object FullName ) -join ' '

        # if ($chapters.trim().length -gt 0) {
        $outFile = "$($targetPath)\book.$($OutputType)"
        Write-Progress -Activity "Generating manuscript" -Status "[$(Get-Date)] Creating $($OutputType)"
        "pandoc $chapters -S --toc --standalone -o $outFile" | Invoke-Expression

        Write-Progress -Activity "Generating manuscript" -Status "[$(Get-Date)] Launching $($OutputType)"
        if ($Show) {
            Invoke-Item $outFile
        }
        # }
        # else {
        #     "No chapters found"
        # }
    }
}

function Test-IsUri {
    param($targetUri)

    [System.Uri]::IsWellFormedUriString($targetUri, 'Absolute')
}