$Environment=Read-Host 'What is the Environment? Ex: Dev or Qual or Production'
$Application=Read-Host 'What is the Application to Deploy? Example: App_Name1, App_Name2, All '

$Local_Desktop=hostname
$Network_Path="C:\Inetpub"

if ( ( $Application -eq "App_Name1" ) -or ($Application -eq "App_Name2") -or ($Application -eq "All") )
{
    if ($Application -eq "All")
    {
        $Application_To_Deploy="App_Name1 & App_Name2"
    } else
    {
        $Application_To_Deploy=$Application
    }
    
    write-host("The application to deploy is  $Application")
   
} else
{
    write-host("Enter a correct Application and retry. Application must be App_Name1 or App_Name2")
    Exit
}


if ($Environment -eq "dev")
{
	    # Replace with your appropriate Server Name, App Name1&2 and Deploy Paths
    	$Deploy_Path_Primary_App_Name2="\\Dev_Server_Name_Primary\Deploy_Path\App_Name2-test\App_Name"
        $Backup_Primary_Path_App_Name2="\\Dev_Server_Name_Primary\Deploy_Path\App_Name2-test\App_Name_Archives"
    	$Deploy_Path_Secondary_App_Name2=""
        $Source_Code_Path_App_Name2="$Network_Path\App_Name_App_Name2_Dev"

       $Deploy_Path_Primary_App_Name1="\\Dev_Server_Name_Primary\Deploy_Path\App_Name1"
       $Backup_Primary_Path_App_Name1="\\Dev_Server_Name_Primary\Deploy_Path\App_Name1_Archives"
       $Deploy_Path_Secondary_App_Name1=""
       $Backup_Secondary_Path_App_Name1=""
       $Source_Code_Path_App_Name1="$Network_Path\App_Name_App_Name1_Dev"

} elseif ($Environment -eq "qual")
{
	#if ( $Application -eq "App_Name2" )
        
        # Replace with your appropriate Server Name, App Name1&2 and Deploy Paths
		$Deploy_Path_Primary_App_Name2="\\Qual_Server_Name_Primary1\Deploy_Path\App_Name-qual\App_Name2"
        $Backup_Primary_Path_App_Name2="\\Qual_Server_Name_Primary1\Deploy_Path\App_Name-qual\App_Name2_Archives"
		$Deploy_Path_Secondary_App_Name2="\\Qual_Server_Name_Secondary\Deploy_Path\App_Name-qual\App_Name2"
		$Backup_Secondary_Path_App_Name2="\\Qual_Server_Name_Secondary\Deploy_Path\App_Name-qual\App_Name2_Archives"
        $Source_Code_Path_App_Name2="$Network_Path\App_Name_App_Name2_Qual"
	
        $Deploy_Path_Primary_App_Name1="\\Qual_Server_Name_Primary2\Deploy_Path\App_Name\App_Name1"
        $Backup_Primary_Path_App_Name1="\\Qual_Server_Name_Primary2\Deploy_Path\App_Name\App_Name1_Archives"
        $Deploy_Path_Secondary_App_Name1="\\Qual_Server_Name_Secondary1\Deploy_Path\App_Name\App_Name1"
        $Backup_Secondary_Path_App_Name1="\\Qual_Server_Name_Secondary2\Deploy_Path\App_Name\App_Name1_Archives"
        $Source_Code_Path_App_Name1="$Network_Path\App_Name_App_Name1_Qual"

} elseif ($Environment -eq "production")
{
        # Replace with your appropriate Server Name, App Name1&2 and Deploy Paths
        $Deploy_Path_Primary_App_Name2="\\Prod_Server_Name_Primary1\Deploy_Path\App_Name-prod\App_Name2"
        $Backup_Primary_Path_App_Name2="\\Prod_Server_Name_Primary1\Deploy_Path\App_Name-prod\App_Name2_Archives"
		$Deploy_Path_Secondary_App_Name2="\\Prod_Server_Name_Secondary1\Deploy_Path\App_Name-prod\App_Name2"
		$Backup_Secondary_Path_App_Name2="\\Prod_Server_Name_Secondary1\Deploy_Path\App_Name-prod\App_Name2_Archives"
        $Source_Code_Path_App_Name2="$Network_Path\App_Name_App_Name2_Prod"
  
        $Deploy_Path_Primary_App_Name1="\\Prod_Server_Name_Primary2\Deploy_Path\App_Name\App_Name1"
        $Backup_Primary_Path_App_Name1="\\Prod_Server_Name_Primary2\Deploy_Path\App_Name\App_Name1_Archives"
        $Deploy_Path_Secondary_App_Name1="\\Prod_Server_Name_Secondary2\Deploy_Path\App_Name\App_Name1"
        $Backup_Secondary_Path_App_Name1="\\Prod_Server_Name_Secondary2\Deploy_Path\App_Name\App_Name1_Archives"
        $Source_Code_Path_App_Name1="$Network_Path\App_Name_App_Name1_Prod"

} else 
{
    write-host("Enter a correct environment and retry. Environment must be Dev, Qual or Production")
    Exit
}

# Create C:\Temp\App_Name Folder if it doesn't exists

New-Item "C:\Temp\App_Name" -type Directory -force

#Creating Archive folder
$current_domainuser=whoami
$current_user=$current_domainuser.split("\")[1]
$current_date=Get-Date -format "yyyyMMddHHmmss"
write-Host ("Current Date:$current_date ") -NoNewLine
write-Host ("Current User:$current_user ") -NoNewLine
$archiveFilePath_Primary_App_Name2="$Backup_Primary_Path_App_Name2\App_Name-$current_date-$current_user"
$archiveFilePath_Primary_App_Name1="$Backup_Primary_Path_App_Name1\App_Name-$current_date-$current_user"
$archiveFilePath_Secondary_App_Name2="$Backup_Secondary_Path_App_Name2\App_Name-$current_date-$current_user"
$archiveFilePath_Secondary_App_Name1="$Backup_Secondary_Path_App_Name1\App_Name-$current_date-$current_user"
write-host("Archive Path Primary App_Name2: $Backup_Primary_Path_App_Name2\App_Name-$current_date-$current_user")
write-host("Archive Path Secondary App_Name2: $Backup_Secondary_Path_App_Name2\App_Name-$current_date-$current_user")

write-host("Archive Path Primary App_Name1: $Backup_Primary_Path_App_Name1\App_Name-$current_date-$current_user")
write-host("Archive Path Secondary App_Name1: $Backup_Secondary_Path_App_Name1\App_Name-$current_date-$current_user")
#New-Item $archiveFilePath_Primary -type Directory -force
#New-Item $archiveFilePath_Secondary -type Directory -force
if ($Environment -ne "dev")
{
    #Dev usually has no secondary server
    if ( $Application -eq "App_Name2" )
    {
    New-Item "c:\Temp\App_Name\App_Name_copy.ps1" -type file -force -value "New-Item $archiveFilePath_Primary_App_Name2 -type Directory -force `nxcopy  /s /e /y $Deploy_Path_Primary_App_Name2 $archiveFilePath_Primary_App_Name2 `nremove-item $Deploy_Path_Primary_App_Name2/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name2 $Deploy_Path_Primary_App_Name2 `n`nNew-Item $archiveFilePath_Secondary_App_Name2 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Secondary_App_Name2 $archiveFilePath_Secondary_App_Name2 `n remove-item $Deploy_Path_Secondary_App_Name2/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name2 $Deploy_Path_Secondary_App_Name2"
    } else {
        if  ( $Application -eq "App_Name1" )
        {
             New-Item "c:\Temp\App_Name\App_Name_copy.ps1" -type file -force -value "New-Item $archiveFilePath_Primary_App_Name1 -type Directory -force `nxcopy  /s /e /y $Deploy_Path_Primary_App_Name1 $archiveFilePath_Primary_App_Name1 `nremove-item $Deploy_Path_Primary_App_Name1/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name1 $Deploy_Path_Primary_App_Name1 `n`nNew-Item $archiveFilePath_Secondary_App_Name1 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Secondary_App_Name1 $archiveFilePath_Secondary_App_Name1 `nremove-item $Deploy_Path_Secondary_App_Name1/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name1 $Deploy_Path_Secondary_App_Name1"

        } else {
            #Deploy Both App_Name2 & App_Name1
            New-Item "c:\Temp\App_Name\App_Name_copy.ps1" -type file -force -value "New-Item $archiveFilePath_Primary_App_Name2 -type Directory -force `nxcopy  /s /e /y $Deploy_Path_Primary_App_Name2 $archiveFilePath_Primary_App_Name2 `nremove-item $Deploy_Path_Primary_App_Name2/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name2 $Deploy_Path_Primary_App_Name2 `n`nNew-Item $archiveFilePath_Secondary_App_Name2 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Secondary_App_Name2 $archiveFilePath_Secondary_App_Name2 `nremove-item $Deploy_Path_Secondary_App_Name2/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name2 $Deploy_Path_Secondary_App_Name2`n`nNew-Item $archiveFilePath_Primary_App_Name1 -type Directory -force `nxcopy  /s /e /y $Deploy_Path_Primary_App_Name1 $archiveFilePath_Primary_App_Name1 `nremove-item $Deploy_Path_Primary_App_Name1/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name1 $Deploy_Path_Primary_App_Name1 `n`nNew-Item $archiveFilePath_Secondary_App_Name1 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Secondary_App_Name1 $archiveFilePath_Secondary_App_Name1 `nremove-item $Deploy_Path_Secondary_App_Name1/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name1 $Deploy_Path_Secondary_App_Name1
            "
        }
    } 
} else
{
    if ( $Application -eq "App_Name2" )
    {
        New-Item "c:\Temp\App_Name\App_Name_copy.ps1" -type file -force -value "New-Item $archiveFilePath_Primary_App_Name2 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Primary_App_Name2 $archiveFilePath_Primary_App_Name2 `nremove-item $Deploy_Path_Primary_App_Name2/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name2 $Deploy_Path_Primary_App_Name2`n`n"
    } else {
        if ( $Application -eq "App_Name1" )
        {
            New-Item "c:\Temp\App_Name\App_Name_copy.ps1" -type file -force -value "New-Item $archiveFilePath_Primary_App_Name1 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Primary_App_Name1 $archiveFilePath_Primary_App_Name1 `nremove-item $Deploy_Path_Primary_App_Name1/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name1 $Deploy_Path_Primary_App_Name1`n"
        } else {
            #Deploy Both App_Name2 & App_Name1
            New-Item "c:\Temp\App_Name\App_Name_copy.ps1" -type file -force -value "New-Item $archiveFilePath_Primary_App_Name2 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Primary_App_Name2 $archiveFilePath_Primary_App_Name2 `nremove-item $Deploy_Path_Primary_App_Name2/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name2 $Deploy_Path_Primary_App_Name2`n`nNew-Item $archiveFilePath_Primary_App_Name1 -type Directory -force`nxcopy  /s /e /y $Deploy_Path_Primary_App_Name1 $archiveFilePath_Primary_App_Name1 `nremove-item $Deploy_Path_Primary_App_Name1/* -recurse -force `nxcopy  /s /e /y $Source_Code_Path_App_Name1 $Deploy_Path_Primary_App_Name1`n
            "
        }
    } 
}




Start-Process  powershell.exe -Credential "Domain\adm_account_name" -NoNewWindow -ArgumentList "-File c:\Temp\App_Name\App_Name_copy.ps1" -WorkingDirectory "C:\Temp\App_Name\"


