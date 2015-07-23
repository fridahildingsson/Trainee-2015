#Import all sharepoint commandlets if not already added
function CheckAddSnapin
{
    if ((Get-PSSnapin -Name "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
    {
        Add-PSSnapin "Microsoft.SharePoint.PowerShell"
        CheckSpSite
    }
    else 
    {
        CheckSpSite
    }
}

#delete sitecollection if there already is one with that name
function CheckSpSite
{
    if ((Get-SPSite "http://dev/zoo/magicalcreatures" -ErrorAction SilentlyContinue) -ne $null)
    {
        Remove-SPSite -Identity "http://dev/zoo/magicalcreatures" -GradualDelete -Confirm:$False
        CreateSpSite
    }
    else
    {
        CreateSpSite
    }
}

function CreateSpSite
{
    #Create site collection
    $Template = Get-SPWebTemplate "STS#1"
    $owner = "BOOLDEVLOCAL\administrator"
    $siteCollectionUrl = "http://dev/zoo/magicalcreatures"
    New-SPSite -Url $siteCollectionUrl -OwnerAlias $owner -Template $Template

    #Inparametrar
    $path = "C:\Users\Administrator\Documents\Magical Creatures"
    $ParentUrl = "http://dev/zoo/magicalcreatures"

    #Run
    CreateSites -path $path -parentUrl $ParentUrl
}

#Loop through folders to create sites, subsites
function CreateSites ([string]$parentUrl, $path) 
{   
    $fc = new-object -com scripting.filesystemobject
    $folder = $fc.getfolder($path)
    $Template = Get-SPWebTemplate "STS#1"
    foreach ($item in $folder.subfolders)
    {
        $siteName= $item.Name
        $url = $parentUrl + "/" + $siteName
        New-SPWeb –url "$url" -name "$siteName" -template $Template


        CreateSites -path $item.path -parentUrl $url
        CreateList -path $item.path -url $url
        AddDescription -path $item.path -url $url
    }
}


#add text to description without #
function AddDescription ($path, [string]$url)
{
    $fc = new-object -com scripting.filesystemobject
    $folder = $fc.getfolder($path)
    foreach ($file in $folder.files) 
    { 
        if ($file.name -eq "description.txt")
        {
            $spWeb = Get-SPWeb -Identity $url
            $descriptionText = Get-Content "$path\description.txt" | Foreach-Object {$_ -replace "\#", ""}
            $spWeb | Set-SPWeb -Description "$descriptionText"       
        }
    }
}

#CreateList
function CreateList ($path, [string]$url)
{
    $fc = new-object -com scripting.filesystemobject
    $folder = $fc.getfolder($path)
    foreach ($file in $folder.files) 
    {
        if ($file.name -eq "creatureinformation.txt")
        {
            $spWeb = Get-SPWeb -Identity $url
            $spTemplate = $spWeb.ListTemplates["Custom List"]
            $spListCollection=$spWeb.Lists
            $listname = "Creature Information"
            $spListCollection.Add("$listname","List about Creature Information",$spTemplate)                 
            $spList = $spWeb.GetList("$url/Lists/$listname")
        
            $spFieldType = [Microsoft.SharePoint.SPFieldType]::Text
            $spList.Fields.Add("CreatureName",$spFieldType,$false)
              
            #$spFieldType = [microsoft.sharepoint.SPFieldType]::DateTime
            $spList.Fields.Add("Found", $spFieldType, $false)
            
            $spFieldType = [Microsoft.SharePoint.SPFieldType]::Number
            $spList.Fields.Add("Evil",$spFieldType,$false)
            

           # $spView = $spWeb.GetViewFromUrl("/Lists/My Contacts/AllItems.aspx")



            ParseFiles -path $path -webUrl $url -listName "$listname"
        }
    }
}


function ParseFiles ($path, [string]$webUrl, [string]$listName)
{
    $content = Get-Content -path "$path\creatureinformation.txt"
        foreach ($line in $content)
        {
            $Creature = ("$line" -Split ',')[0].Substring(10)
            $Found = ("$line" -Split ',')[1].Substring(7)
            $evil = ("$line" -Split ',')[2].Substring(7).TrimEnd(";")
            $web = Get-SPWeb $webURL
            $list = $web.Lists[$listName]
            $newItem = $list.Items.Add()
            $newItem["Title"] = "$creature"
            $newItem["CreatureName"] = "$creature"
            $newItem["Found"] = "$Found"
            $newItem["Evil"] = "$evil"
            $newItem.Update()
        }  
}


CheckAddSnapin






<##Create WebApplication FUNKAR INTE!! OBS! WHYYY?!?!?
$ap = New-SPAuthenticationProvider
New-SPWebApplication -Name "Magical creatures" -ApplicationPool "Magicalcreatures" -ApplicationPoolAccount "BOOLDEVLOCAL\sp_apppool" -Port 4990 -URL "http://dev" #-AuthenticationProvider $ap 

#create managed path
$managedPathName = "zoo"
$webApplicationUrl = "http://dev"
New-SPManagedPath –RelativeURL $managedPathName -WebApplication $webApplicationUrl


#DeleteAllSites
Get-SPSite "http://dev/zoo/magicalcreatures/" | Get-SPWeb -Limit All | ForEach-Object {Remove-SPWeb -Identity $_ -Confirm:$false}#>
