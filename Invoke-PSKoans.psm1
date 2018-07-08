function Invoke-PSKoans {
    [CmdletBinding()]
    [Alias('Rake')]
    param()

    Write-Host -ForegroundColor Cyan @"
    Welcome, seeker of enlightenment. 
    Please wait a moment while we examine your karma...

"@
    $Red = @{
        ForegroundColor = "Red"
    }
    $Blue = @{
        ForegroundColor = "Cyan"
    }
    $PesterTestCount = Invoke-Pester -PassThru -Show None | Select-Object -ExpandProperty TotalCount

    $Tests = Get-ChildItem -Path "$PSScriptRoot\Koans" -Filter '*.Tests.ps1'

    foreach ($KoanFile in $Tests) {
        $PesterTests = Invoke-Pester -PassThru -Show None -Script $KoanFile.FullName

        if ($PesterTests.FailedCount -gt 0) {
            $NextKoanFailed = $PesterTests.TestResult | 
                Where-Object Result -eq 'Failed' |
                Select-Object -First 1
        
            Write-Host @Red @"
    {Describe "$($NextKoanFailed.Describe)"} has damaged your karma.
"@
            Write-Host @Blue @"

    You have not yet reached enlightenment.
    
    The answers you seek...
"@
            Write-Host @Red @"
    $($NextKoanFailed.ErrorRecord)
"@
            Write-Host @Blue @"
    
    Please meditate on the following code:
"@
            Write-Host @Red @"
    $($NextKoanFailed.StackTrace)
"@
            Write-Host @Blue @"

    Mountains are merely mountains.
        
    Your path thus far: 
"@
            $Width = $host.UI.RawUI.WindowSize.Width - 7
            $PortionDone = ($PesterTests.PassedCount / $PesterTestCount) * $Width
            Write-Host @Blue (
                "[{0}{1}] {2}/{3}" -f @(
                    "$([char]0x25a0)" * $PortionDone
                    "$([char]0x2015)" * ($Width - $PortionDone)
                    $PesterTests.PassedCount
                    $PesterTestCount
                )
            )
            break
        }
    }
}