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
##  Author: Aline Tognini (aline.tognini@microsoft.com) - v 1.2, 05/25/2021
##
##  Get-SP2010WorkflowListInformation - Reads additional info for OOTB 2010 workflows and its lists using the Modernization Scanner report as input.
##     v 1.2: Changing column separator/delimiter to "##" so as not to break workflow messages using comma at the "AssociationData" field. Output file must be imported to Excel, though.  
##
############################################################################################################
## Requirements:
## This script requires PnP PowerShell 1.5.0 or above.
################################# Variables Area ##################################

# Sort the input file by Site Collection URL, List URL in order to get optimal processing 
$modernizationScanFile = "C:\temp\ModernizationWorkflowScanResults.csv"

$savedFilePath = "C:\temp\"

$myTimeStamp = Get-Date -Format MMddyyyy-hhmmss

$successFile = $savedFilePath + "spo_wkflistdetails_" + $myTimeStamp + ".csv"

Add-Content -Path $successFile -Value "Site Collection Url##List Url##List Id##BaseTemplate##BaseType##DraftVersionVisibility##EnableAttachments##EnableMinorVersions##EnableModeration##EnableVersioning##MajorVersionLimit##MajorWithMinorVersionsLimit##WA Id##WA Name##WA BaseId##WA AllowManual##WA AutoStartChange##WA AutoStartCreate##WA Enabled##WA HistoryListTitle##WA AssociationData" 

# This will process OOTB Approvals only:
# Please change, based on each OOTB template scanned per run
$definitionName = "Approval - SharePoint 2010" 
$isWfEnabled = "TRUE"

$clientId = ""
$clientSecret = ""

################################# End of Variables Area ###########################

## Step 1: Loads Modernization Scanner workflow results:
$msoResults = Import-Csv $modernizationScanFile  

foreach ($sp2010wf in $msoResults){
    # Checks if this is a list workflow, and its definition name:
    
    if (($sp2010wf.'Definition Name' -eq $definitionName)  -and ($sp2010wf.Enabled -eq $isWfEnabled)){
       
        # Using Connect-PnPOnline automatically disconnects from previous sites, so it's rarely needed to use Disconnect-PnPOnline. 
        Connect-PnPOnline -Url $sp2010wf.'Site Url' -ClientId $clientId -ClientSecret $clientSecret -WarningAction Ignore #-UseWebLogin 

        # Retrieves Workflow Association Information:
        $list = Get-PnPList -Identity $sp2010wf.'List Id' -Includes WorkflowAssociations

        if( $list -ne $null ) {
            Write-Host "WorkflowAssociation found: $($sp2010wf.'Site Collection Url') - list $($sp2010wf.'List Url') - WF count: $($list.WorkflowAssociations.Count)" -BackgroundColor Blue -ForegroundColor White

            foreach ($wfInst in $list.WorkflowAssociations){
            
                Add-Content -Path $successFile -Value "$($sp2010wf.'Site Collection Url')##$($sp2010wf.'List Url')##$($sp2010wf.'List Id')##$($list.BaseTemplate)##$($list.BaseType)##$($list.DraftVersionVisibility)##$($list.EnableAttachments)##$($list.EnableMinorVersions)##$($list.EnableModeration)##$($list.EnableVersioning)##$($list.MajorVersionLimit)##$($list.MajorWithMinorVersionsLimit)##$($wfInst.Id)##$($wfInst.Name)##$($wfInst.BaseId)##$($wfInst.AllowManual)##$($wfInst.AutoStartChange)##$($wfInst.AutoStartCreate)##$($wfInst.Enabled)##$($wfInst.HistoryListTitle)##$($wfInst.AssociationData)"
            }
                
        }

    }

}
