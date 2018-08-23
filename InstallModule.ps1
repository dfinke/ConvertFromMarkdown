$fullPath = 'C:\Program Files\WindowsPowerShell\Modules\ConvertFromReadmeMD'

Robocopy . $fullPath /mir /XD .vscode .git /XF appveyor.yml