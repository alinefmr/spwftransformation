# SharePoint Workflows Transformation to Power Automate
As SharePoint 2010 workflows have been [retired since August 1st, 2020](https://support.microsoft.com/en-us/office/sharepoint-2010-workflow-retirement-1ca3fff8-9985-410a-85aa-8120f626965f#:~:text=After%20careful%20consideration%2C%20we%20concluded%20that%20for%20SharePoint,removed%20from%20existing%20tenants%20on%20November%201%2C%202020.), this project is intended to pull legacy configuration out of existing SPO Lists using PowerShell. 

Get-SP2010WorkflowListInformation.ps1 - This script uses the SharePoint Modernization Scanner report as input, and collects additional information from list workflow associations.

Get-SP2013XomlInfo.ps1 - This script programtically collects XOML definitions. 
