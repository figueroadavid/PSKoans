$ProjectRoot = Resolve-Path "$PSScriptRoot/.."
$KoanFolder = $ProjectRoot | Join-Path -ChildPath 'PSKoans' | Join-Path -ChildPath 'Koans'

Describe "Koan Assessment" {

    $Scripts = Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.Koans.ps1'
    
    # TestCases are splatted to the script so we need hashtables
    $TestCases = $Scripts | ForEach-Object { @{File = $_ } }
    It "<File> koans should be valid powershell" -TestCases $TestCases {
        param($File)

        $File.FullName | Should -Exist

        $Errors = $Tokens = $null
        [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$Tokens, [ref]$Errors) > $null
        $Errors.Count | Should -Be 0
    }

    It "<File> should include one (and only one) line feed at end of file" -TestCases $TestCases {
        param($File)
        $crlf = [Regex]::Match(($File | Get-Content -Raw), '(\r?(?<lf>\n))+\Z')
        $crlf.Groups['lf'].Captures.Count | Should -Be 1
    }

}
