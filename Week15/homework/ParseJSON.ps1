#Stroyline: Parse the NVD Datafeed

<#
    .Synopsis
        Script to parse the lastes NVD dataset feed.
         
    .Description
        This file will parse a json file and return the results as a CSV file.

    .Example
        .\ParseJSON.ps1 -y "2020" -k "cisco" -f "nvd-data.csv"

    .Example
        .\ParseJSON.ps1 -year "2020" -kWord "java" -fName "nvd-data.csv"

    .Notes
        Created by Quentin DeGiorgio. Dec 14, 2021.                                                                                                                                                                                                                                                                                                                                         baba Booey 
#>

param(
    
    [Alias("y")]
    [Parameter(Mandatory=$true)]
    [int]$year,

    [Alias("k")]
    [Parameter(Mandatory=$true)]
    [string]$kWord,

    [Alias("f")]
    [Parameter(Mandatory=$true)]
    [string]$fName
)



# I think we all know what this dones :)
cls

# Convert JSON into PS Obj
$nVulns = (Get-Content -Raw -Path ".\nvdcve-1.1-2021.json") | ConvertFrom-Json | select CVE_Items

# CSV File
$fName = "nvd-data-$(Get-Date -f yyyy-MM-dd).csv" 

# Headers for the CSV File
Set-Content -Value "`"PublishDate`",`"Description`",`"Impact`",`"CVE`"" $fName 

# Array to Store Data
$theV = @()

foreach ($vuln in $nVulns.CVE_Items) {

  # Vuln Description 
  $descr = $vuln.cve.description.description_data

  $kWord = "java"

  # Search for Keyword
  if ($descr -imatch "$kWord") {

    # Publish Date 
    $pDate = $vuln.publishedDate

    # Description
    $z = $descr | select value 
    $description = $z.value

    # Impact
    $i = $vuln.impact 
    $impact = $i.baseMetricV2.severity

    # CVE Num
    $cve = $vuln.cve.CVE_data_meta.ID

    # Format the CSV
    $theV += "`"$pDate`",`"$description`",`"$impact`",`"$cve`"`n"

  }

}
# Convert Array to STR and Append 
"$theV" | Add-Content -Path $fName

