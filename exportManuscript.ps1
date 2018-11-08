function Export-Manuscript {
    param(
        $markdownFile = "$pwd\README.md",
        $outputPath = $pwd,
        [ValidateSet('txt', 'md')]
        $chapterExtension = "txt"
    )

    $manuscriptPath = "$outputPath\manuscript"

    Remove-Item -Recurse -Force $manuscriptPath -ErrorAction Ignore

    $null = mkdir $manuscriptPath

    $chapters = [ordered]@{}
    $chapterIndex = 0

    if (!(Test-IsUri $markdownFile)) {
        $markdownContent = Get-Content $markdownFile
    }
    else {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $markdownContent = Invoke-RestMethod $markdownFile
        $markdownContent = $markdownContent -split "`n"
    }

    if (!($markdownContent -contains "<!-- CHAPTER START -->")) {
        $inChapter = $true
        $markdownContent += "<!-- CHAPTER END -->"
    }

    # switch -File ($markdownFile) {
    switch ($markdownContent) {

        "<!-- CHAPTER END -->" {
            $inChapter = $false
            $chapterIndex += 1
        }

        {$inChapter} {
            $currentChapter = "chapter{0:0#}" -f $chapterIndex
            if (!$chapters.$currentChapter) {
                $chapters.$currentChapter = @()
            }

            $chapters.$currentChapter += $_
        }

        "<!-- CHAPTER START -->" {$inChapter = $true}
    }

    foreach ($chapter in $chapters.Keys) {

        #$chapter
        $chapterName = "$($chapter).$($chapterExtension)"
        $chapterFile = "$($manuscriptPath)\$($chapterName)"

        $chapters.$chapter | Set-Content -Encoding Ascii $chapterFile
        $chapterName >> "$manuscriptPath\Book.txt"
    }
}