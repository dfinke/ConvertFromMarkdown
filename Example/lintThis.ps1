function Invoke-TrimString {
    param($targetText)

    $targetText -replace '^[ \t]+|[ \t]+$', ''
}

function Invoke-StripAll {
    param($targetText, $pattern)

    $count = 0
    $targetText -replace $pattern, ''
}

