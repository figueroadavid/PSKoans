$PSDefaultParameterValues["Remove-PSKoans:WhatIf"] = $true

function Remove-PSKoans
{
    <#
    .SYNOPSIS
        Removes the PSKoans folder from the user profile
    .DESCRIPTION
        Removes the PSKoans folder from the user profile
    .EXAMPLE
        PS C:\> Remove-PSKoans
        What if: Performing the operation "Remove PSKoans history from the location: C:\Users\<username>" on target "PSKoans".
    .EXAMPLE
        PS C:\> Remove-PSKoans -WhatIf:$false
        Remove-PSKoans
        Confirm
        Are you sure you want to perform this action?
        Performing the operation "Remove Directory" on target "C:\Users\<username>\PSKoans".
        [Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): A
    .INPUTS
        none
    .OUTPUTS
        [system.string]
    .NOTES
        By default, Remove-PSKoans is is set to use the -WhatIf parameter as a safety measure.
        In order to really remove the PSKoans, use it with -WhatIf:$False, and when the
        prompt comes up to remove the directory, each subdirectory will prompt the user, unless
        the 'A' option is selected.

    #>
    [CmdletBinding(SupportsShouldProcess)]
    param()
    $PSKoansPath = Get-PSKoanLocation
    $WhatIfMessage = 'Remove PSKoans history from the location: {0}' -f (Split-Path -path $PSKoansPath -Parent)
    $WhatIfTarget = Split-Path -Path $PSKoansPath -Leaf

    if (Test-Path -Path $PSKoansPath)
    {
        if ($PSCmdlet.ShouldProcess($WhatIfTarget, $WhatIfMessage))
        {
            Remove-Item -Path $PSKoansPath -Recurse -Confirm
        }
    }
    else
    {
        Write-Output 'You have not committed to the path of enlightenment; your history of PSKoans is sadly missing'
    }
}