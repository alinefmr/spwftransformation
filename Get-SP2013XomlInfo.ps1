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
##  Author: Aline Tognini (aline.tognini@microsoft.com) - v 1.1, 07/08/2021
##
##  Get-SP2013XomlInfo - Exports xoml workflow definition info using the Modernization Scanner report as input.
##
############################################################################################################
## Requirements:
##
## This script requires legacy PnP PowerShell module "SharePointPnPPowerShellOnline" (v. 3.29.2101.0) - do not use "PnP.PowerShell" as 
##   Workflow cmdlets have been deprecated in the unified module: https://pnp.github.io/powershell/articles/upgrading.html
##
##  Output file: .csv uses "##" as a custom separator, in order to avoid conflict with comma use in other places in the data. Please open a blank
##     Excel file and import csv using "Custom" delimiter.
##
################################# Variables Area ##################################

# Sort the input file by Site Collection URL, List URL in order to get optimal processing 
$modernizationScanFile = "C:\temp\ModernizationWorkflowScanResults.csv"

$savedFilePath = "C:\temp\"

$myTimeStamp = Get-Date -Format MMddyyyy-hhmmss

$successFile = $savedFilePath + "spo_wkflxomldetails_" + $myTimeStamp + ".csv"

Add-Content -Path $successFile -Value "Site Collection Url##DisplayName##FormField##Id##RequiresAssociationForm##RequiresInitiationForm##RestrictToScope##RestrictToType##Xaml" 

$isWfEnabled = "TRUE"
$wfVersion = "2013"

################################# End of Variables Area ###########################

## Step 1: Loads Modernization Scanner workflow results:
$msoResults = Import-Csv $modernizationScanFile  

foreach ($spWf in $msoResults){
    # Checks if this is a list workflow, and its definition name:
    
    if (($spWf.'Version' -eq $wfVersion)  -and ($spWf.Enabled -eq $isWfEnabled) ){
       
        # Using Connect-PnPOnline automatically disconnects from previous sites, so it's rarely needed to use Disconnect-PnPOnline. 
        Connect-PnPOnline -Url $spWf.'Site Url' -UseWebLogin  -WarningAction SilentlyContinue

        #SP2013 workflows: retrieves XOML definitions:
        $spXomls = Get-PnPWorkflowDefinition

        foreach ($xaml in $spXomls){
            Add-Content -Path $successFile -Value "$($spWf.'Site Collection Url')##$($xaml.'DisplayName')##$($xaml.'FormField')##$($xaml.'Id')##$($xaml.'RequiresAssociationForm')##$($xaml.'RequiresInitiationForm')##$($xaml.'RestrictToScope')##$($xaml.'RestrictToType')##$($xaml.'Xaml')"        
        }
    }

}


