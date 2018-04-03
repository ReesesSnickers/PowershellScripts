
function ClearSpace
{
    $TimeLimitation = (Get-Date).AddDays(-1)
    $MainTempDir = "C:\Windows\Temp"
    $MainTempSpecs = Get-ChildItem -Path $TempPath | Measure-Object -Sum Length
    $CurrentUserTempSpecs = Get-ChildItem -Path $env:TEMP | Measure-Object -Sum Length
    $Memory = Get-WmiObject Win32_PhysicalMemory
    $DiskSpace = Get-WmiObject Win32_DiskDrive

    $MainTempInfo = @{"FileCount" = $MainTempSpecs.Count;
                      "TotalFolderSize" = (("{0:N2}" -f ($MainTempSpecs.Sum/1GB)) + ' GB')}
    $MainTemp = New-Object -TypeName PSObject -Property $MainTempInfo
    
    $DriveInfo = @{"PhysicalMemory" = (("{0:N2}" -f ($Memory.Capacity/1GB)) + ' GB');
                   "DiskSize" = (("{0:N2}" -f ($DiskSpace.Size/1GB)) + ' GB')}
    $Drive = New-Object -TypeName PSObject -Property $DriveInfo

    $CurrentTempInfo = @{"FileCount" = $CurrentUserTempSpecs.Count;
                      "TotalFolderSize" = (("{0:N2}" -f ($CurrentUserTempSpecs.Sum/1GB)) + ' GB')}
    $CurrentTemp = New-Object -TypeName PSObject -Property $CurrentTempInfo

    #Notes origional file count and total sizes for paths.
    Write-Output "Preparing to ClearSpace..."
    Write-Output " "
    #ScriptLogCheck
    Write-Output " "
    Write-Output "CURRENT STATISTICS FOR DEVICE ARE AS FOLLOWS"
    Write-Output $Drive
    Write-Output " "
    Write-Output "CURRENT STATISTICS FOR $MainTempDir ARE AS FOLLOWS"
    Write-Output $MainTemp
    Write-Output "CURRENT STATISTICS FOR $env:Temp ARE AS FOLLOWS"
    Write-Output $CurrentTemp
    
    #Deletes main Temp folder files then deletes leftover directories.
    Write-Output "Clearing space within $MainTempDir. Please be patient."
    Get-ChildItem -Path $TempPath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $TimeLimitation } | Remove-Item -Force
    Get-ChildItem -Path $TempPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

    #Deletes current user's Temp files then deletes left over directories.
    Write-Output "Clearing space within $MainTempDir. Please be patient."
    Get-ChildItem -Path $env:Temp -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $TimeLimitation } | Remove-Item -Force
    Get-ChildItem -Path $env:Temp -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse


}

function ScriptLogCheck
{
    $LogDir = "$env:LOCALAPPDATA\Local\Temp\ClearSpaceLog"
    $ScriptLog = "$LogDir\RunLog.txt"
    
    if(!Test-Path $LogDir)
    {
        New-Item $LogDir -ItemType directory
        if(Test-Path $LogDir)
        {
            New-Item $ScriptLog -ItemType file
            if(!Test-Path $ScriptLog)
            {
                Write-Error "Unable to create log file."
            }
        }
        else
        {
            Write-Error "Unable to create directory."
        }
        
    }
    else
    {
        if(!Test-Path $ScriptLog)
        {
            New-Item $ScriptLog -ItemType file
            if(!Test-Path $ScriptLog)
            {
                Write-Error "Unable to create log file."
            }
        }
        else
        {
            Write-Output "Directory and log file already exist. Proceeding to gather data..."
        }
    }
}