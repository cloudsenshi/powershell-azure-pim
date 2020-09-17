##########
# Pre-Req
# https://www.powershellgallery.com/packages/AzureADPreview/2.0.2.105
# Install-Module -Name AzureADPreview
##########

##########
# Step 0 #
##########
Connect-AzureAD

##########
# Step 1 #
##########
# Get the ExternalId of the subscription you want to JIT to be used as ResourceId in the next cmd. Note that ExternalId is different from each subscription
Get-AzureADMSPrivilegedResource -ProviderId AzureResources | Where-Object {($_.Type -like 'subscription')}
<#
PS C:\WINDOWS\system32> Get-AzureADMSPrivilegedResource -ProviderId AzureResources | Where-Object {($_.Type -like 'subscription')}


Id                  : 1a6ac69b-31ea-4788-ab58-fad6446b5793
ExternalId          : /subscriptions/12345678-a35c-4b87-acd0-72c98a299876
Type                : subscription
DisplayName         : 
Status              : Active
RegisteredDateTime  : 
RegisteredRoot      : 
RoleAssignmentCount : 
RoleDefinitionCount : 
Permissions         : 
#>

##########
# Step 2 #
##########
# Create schedule object here
$schedule = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedSchedule
$schedule.Type = "Once"
$schedule.StartDateTime = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")

#Adjust End Time Here!!!
$schedule.endDateTime = "2020-09-17T20:00:00.770Z"

##########
# Step 3 #
##########
# Activate Contributor Role
# Get ResourceId on Step 1
# Replace RoleDefinitionId by the RBAC RoleId you want to elevate (i.e. Owner=6ce206bf-05c1-4c45-8a6e-76afe7f60b35, Contributor=7f6c0fa8-2840-4f6e-98ab-44a263fd4652)
# Replace SubjectId by your AAD ObjectID ==> Go to Azure Active Directory ==> Users and look for your account then get the ObjectId

Open-AzureADMSPrivilegedRoleAssignmentRequest -ProviderId 'AzureResources' `
    -ResourceId '1a6ac69b-31ea-4788-ab58-fad6446b5793' `
    -RoleDefinitionId '7f6c0fa8-2840-4f6e-98ab-44a263fd4652' `
    -SubjectId '5d0d5bab-132f-493c-a4f9-ae7e2268ff76' `
    -Type 'UserAdd' `
    -AssignmentState 'Active' `
    -schedule $schedule `
    -reason "Test from PowerShell"