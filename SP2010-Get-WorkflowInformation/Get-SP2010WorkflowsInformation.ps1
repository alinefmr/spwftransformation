############################################################################################################
## DISCLAIMER:
## Copyright (c) Microsoft Corporation. All rights reserved. This
## script is made available to you without any express, implied or
## statutory warranty, not even the implied warranty of
## merchantability or fitness for a particular purpose, or the
## warranty of title or non-infringement. The entire risk of the
## use or the results from the use of this script remains with you.
##
##
##  Author: Aline Tognini (aline.tognini@microsoft.com) - v 0.1, 04/15/2021
##
##  Get-SP2010WorkflowsInformation - Reads additional info for OOTB 2010 workflows using the Modernization Scanner report as input.
##
############################################################################################################
## Requirements:
## This script requires PnP PowerShell 1.5.0 or above.
## Connection uses Client Id and Secret with full read permissions. 

################################# Variables Area ##################################

$modernizationScanFile = "C:\CE\DSE\KP\2010WF\637297229466061285\ModernizationWorkflowScanResults.csv"

# This will process OOTB Approvals only:
$definitionName = "Approval - SharePoint 2010"
$wfScope = "List"
$isWfEnabled = "TRUE"

$ClientId = Read-Host -Prompt 'Enter Client Id'
$ClientSecret = Read-Host -Prompt 'Enter Client Secret'

################################# End of Variables Area ###########################

## Step 1: Loads Modernization Scanner workflow results:
$msoResults = Import-Csv $modernizationScanFile  

foreach ($sp2010wf in $msoResults){
    # Checks if this is a list workflow, and its definition name:
    
    if (($sp2010wf.'Definition Name' -eq $definitionName) -and ($sp2010wf.'Scope' -eq $wfScope) -and ($sp2010wf.Enabled -eq $isWfEnabled)){
       
        Connect-PnPOnline -Url $sp2010wf.'Site Url' -ClientId $ClientId -ClientSecret $ClientSecret

        # Retrieves Workflow Association Information:
        $list = Get-PnPList -Identity $sp2010wf.'List Id' -Includes WorkflowAssociations

        if( $list -ne $null ) {
            #Write-Host "WorkflowAssociations: $($list.WorkflowAssociations.Count)" -BackgroundColor Blue -ForegroundColor White

            $wfFields = @()

            foreach($p in $list.WorkflowAssociations) 
            {
                $wfFields += @{$p.Name = $p.Value}
            }
                
        }
    }

}


