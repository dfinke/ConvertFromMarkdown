$fullPath = 'C:\Program Files\WindowsPowerShell\Modules\ConvertFromMarkdown'

Robocopy . $fullPath /mir /XD .vscode .git /XF appveyor.yml