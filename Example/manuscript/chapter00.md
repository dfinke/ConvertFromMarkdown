# STRINGS

## Trim leading and trailing white-space from string

This is an alternative to using the `Trim()` method. The
function below works by finding all leading and trailing white-space and
removing it from the start and end of the string.

**Example Function:**

```ps
function Invoke-TrimString {
    param($targetText)

    $targetText -replace '^[ \t]+|[ \t]+$', ''
}
```

**Example Usage:**

```powershell
PS C:\> Invoke-TrimString "    Hello,  World    "
Hello,  World

PS C:\> $name = "   John Black  "
PS C:\> Invoke-TrimString $name
John Black
```

## Strip all instances of pattern from string

**Example Function:**

```ps
function Invoke-StripAll {
    param($targetText, $pattern)

    $count = 0
    $targetText -replace $pattern, ''
}
```

**Example Usage:**

```powershell
PS C:\> Invoke-StripAll "The Quick Brown Fox" "[aeiou]"
Th Qck Brwn Fx

PS C:\> Invoke-StripAll "The Quick Brown Fox" " "
TheQuickBrownFox

PS C:\> Invoke-StripAll "The Quick Brown Fox" "Quick "
The Brown Fox
```

