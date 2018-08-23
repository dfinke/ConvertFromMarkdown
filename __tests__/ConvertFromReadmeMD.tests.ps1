Describe "Converfrom ReadmdMD" {

    BeforeAll {
        Import-Module $PSScriptRoot\..\ConvertFromMarkdown.psm1 -Force
    }

    AfterEach {
        Remove-Item $env:TEMP\manuscript -Recurse -Force -ErrorAction Ignore
        Remove-Item $env:TEMP\lintThis.ps1 -Force -ErrorAction Ignore
    }

    It "Should create a manuscript folder" {
        ConvertFrom-Markdown $PSScriptRoot\README.md $env:TEMP

        Test-Path $env:TEMP\manuscript | Should Be $true
        Test-Path $env:TEMP\lintThis.ps1 | Should Be $true
    }

    It "Should have six files in the manuscript directory" {
        ConvertFrom-Markdown $PSScriptRoot\README.md $env:TEMP

        (Get-ChildItem $env:TEMP\manuscript | Measure-Object ).Count | Should Be 6
    }

    It "Read from the web, should have six files in the manuscript directory" {
        ConvertFrom-Markdown https://raw.githubusercontent.com/dfinke/ConvertFromMarkdown/master/__tests__/README.md $env:TEMP
        (Get-ChildItem $env:TEMP\manuscript | Measure-Object ).Count | Should Be 6
    }

    It "Should have book.md in the manuscript directory" {
        ConvertFrom-Markdown $PSScriptRoot\README.md $env:TEMP

        Test-Path $env:TEMP\manuscript\book.txt | Should Be $true
    }

    It "Should have five chapter files in the manuscript directory" {
        ConvertFrom-Markdown $PSScriptRoot\README.md $env:TEMP

        (Get-ChildItem $env:TEMP\manuscript chapter*.txt | Measure-Object ).Count | Should Be 5
    }

    It "Should create a manuscript folder no code blocks" {
        ConvertFrom-Markdown $PSScriptRoot\READMEOneChapterNoCode.md $env:TEMP

        Test-Path $env:TEMP\manuscript | Should Be $true
        Test-Path $env:TEMP\lintThis.ps1 | Should Be $false
    }

    It "Should create a test code blocks and delete lint file" {
        $actual = Test-PSCodeBlock $PSScriptRoot\READMEGoodCode.md $env:TEMP
        $actual | Should Be "all analyzed - no issues"
        Test-Path $env:TEMP\lintThis.ps1 | Should Be $false
    }

    It "Reads from the web, should create a test code blocks and delete lint file" {
        $actual = Test-PSCodeBlock https://raw.githubusercontent.com/dfinke/ConvertFromMarkdown/master/__tests__/READMEGoodCode.md $env:TEMP
        $actual | Should Be "all analyzed - no issues"
        Test-Path $env:TEMP\lintThis.ps1 | Should Be $false
    }

    It "Should keep lint file" {
        $actual = Test-PSCodeBlock $PSScriptRoot\READMEGoodCode.md $env:TEMP -KeepLintFile
        $actual | Should Be "all analyzed - no issues"

        Test-Path $env:TEMP\lintThis.ps1 | Should Be $true
    }

    It "Should handle errors in the fenced blocks" {
        $actual = Test-PSCodeBlock $PSScriptRoot\READMECodeThatErrors.md $env:TEMP
        $actual | Should Not Be "all analyzed - no issues"

        Test-Path $env:TEMP\lintThis.ps1 | Should Be $true
    }

    It "Should respect excluded blocks" {
        $actual = Test-PSCodeBlock $PSScriptRoot\READMEExcludeCode.md $env:TEMP
        $actual | Should Be "all analyzed - no issues"

        Test-Path $env:TEMP\lintThis.ps1 | Should Be $false
    }

    It "Should fail as a Uri" {
        Test-IsUri .\README.md | Should Be $false
    }

    It "Should be a Uri" {
        Test-IsUri https://raw.githubusercontent.com/dfinke/ConvertFromMarkdown/master/README.md | Should Be $true
    }

    AfterAll {
        Remove-Item $env:TEMP\manuscript -Recurse -Force -ErrorAction Ignore
        Remove-Item $env:TEMP\lintThis.ps1 -Force -ErrorAction Ignore
    }

}