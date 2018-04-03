<#
.SYNOPSIS

Validates the W32TM Leap Indicator Status

.DESCRIPTION

Validates the W32TM Indicator Status. Run's
a resync if the Leap Indicator status is 3.
Afterward posts the results.

.INPUTS

None. You cannot pipe objects to Invoke-WTSSync.

.OUTPUTS

System.Object. Invoke-WTSSync returns a object
containing the process results.

.EXAMPLE



.NOTES

Author:            Bobbylee G. Ingalls
Current Version:   1.0.0.0
v1 Creation Date:  4/2/2018
Last Review Date:  4/2/2018

For Version control log see the readme file for this script at hte github repository link.

.LINK



.COMPONENT

Powershell v3.0 or higher.

.ROLE

Intended for system administrators and IT technicians.

.FUNCTIONALITY

Intended to correct sync issues regarding System
Event ID 134 regarding Windows Time Service Issues
on a standard home client PC.

#>
#region Invoke-WTSSync Cmdlet code
Function Invoke-WTSSync
{
    [cmdletbinding()]
    Param()    
    
    $Script:WTSStatus = 'Scripting error occured'
    $Script:Resync = 'False'
    $Script:Computername = $env:COMPUTERNAME
    $Script:WindowsTimeServiceStatus = (Invoke-Command {W32TM /query /status})
    $Time = Get-Date


    Write-Verbose 'Validating Windows Time Service Status...'
    Write-Host "Validating WTS."
    If($Script:WindowsTimeServiceStatus[0] -like "Leap Indicator: 0*")
    {        
        Write-Verbose "Windows Time Service Leap Indicator validated as 0."
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        $Script:WTSStatus = '0'
        Write-Debug "`$Script:WTSStatus is: $Script:WTSStatus"
    }
    Elseif($Script:WindowsTimeServiceStatus[0] -like "Leap Indicator: 1*")
    {
        Write-Host "W32TM Leap Indicator Code not defined. You may need to investigate additional codes at https://social.technet.microsoft.com/Forums/windowsserver/en-US/ff395dec-f745-4f29-9cbd-f0ee7c899580/w32tm?forum=winservergen ."
        Write-Verbose "Windows Time Service Leap Indicator validated as 1."
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        Throw "Windows Time Service Leap Indictor status was validated as 1 and is not a known status within this command."
    }
    Elseif($Script:WindowsTimeServiceStatus[0] -like "Leap Indicator: 3*")
    {
        Write-Verbose "Windows Time Service Leap Indicator validated as 3."
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        $Script:Resync = 'True - Unverified'
        Write-Debug "`$Script:WTSStatus is: $Script:WTSStatus"
        Write-Error "Windows Time Service LEap Indicator status validated as 3."
        Sync
    }
    else
    {
        Write-Host "'"'$WindowsTimeServiceStatus[0]'"' not defined. You may need to investigate additional codes at https://social.technet.microsoft.com/Forums/windowsserver/en-US/ff395dec-f745-4f29-9cbd-f0ee7c899580/w32tm?forum=winservergen ."
        Write-Verbose "Windows Time Service Leap Indicator validated as 0."
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        $Script:WTSStatus = 'Unknown'
        Write-Debug "`$Script:WTSStatus is: $Script:WTSStatus"
        Throw "Windows Time Service Leap Indictor status was validated as a unknown status error indicator."
    }

    Write-Verbose "Posting status results..."
    $Results = [PSCustomObject]@{
        ComputerName = $Script:Computername
        WTS_Status = $Script:WTSStatus
        ResyncRequired = $Script:Resync    
    }
}

Function Sync
{
    Write-Verbose "Preparing to attempt Windows Time Sernvice resync..."
    Write-Host "Attempting to resync WTS..."
    Invoke-Command {W32TM /resync}
    Write-Verbose "Validating Windows Time Service after sycronization..."
    Write-Host "Validating WTS after syncronization..."
    If($Script:WindowsTimeServiceStatus[0] -like "Leap Indicator: 0*")
    {
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        Write-Verbose "Windows Time Service Leap Indicator validated as 0 after syncronisation."
        Write-Verbose "Validating for System event id 37 and 137..."
        Write-Debug "`$Time is: $Time"
        If((Get-Eventlog -LogName System -InstanceId 37 -After $Time) -and (!Get-Eventlog -LogName System -InstanceId 137 -After $Time))
        {
            Write-Verbose "System event id 37 detected after sycronization..."
            Write-Verbose "System event id 137 not detected after sycronization..."
            Write-Verbose "Windows Time Service successfully syncronised."
            $Script:Resync = 'True - 37 detected / 137 undetected'
            Write-Debug "`$Script:Resync is: $Script:Resync"
        }
        Elseif((Get-Eventlog -LogName System -InstanceId 137 -After $Time) -and (!Get-Eventlog -LogName System -InstanceId 37 -After $Time))
        {
            Write-Verbose "System event id 37 not detected after sycronization..."
            Write-Verbose "System event id 137 detected after sycronization..."
            Write-Verbose "Windows Time Service successfully syncronised."
            $Script:Resync = 'True - 137 detected / 37 undetected'
            Write-Debug "`$Script:Resync is: $Script:Resync"
        }
        Elseif((Get-Eventlog -LogName System -InstanceId 37 -After $Time) -and (Get-Eventlog -LogName System -InstanceId 137 -After $Time))
        {
            Write-Verbose "System event id 37 detected after sycronization..."
            Write-Verbose "System event id 137 detected after sycronization..."
            Write-Verbose "Windows Time Service successfully syncronised."
            $Script:Resync = "True - Both event's detected"
            Write-Debug "`$Script:Resync is: $Script:Resync"
        }
        Else
        {
            Write-Verbose "System event id 37 not detected after sycronization..."
            Write-Verbose "System event id 137 not detected after sycronization..."
            Write-Error "Windows Time Service syncronization verification was unable to determin success or failure."
            $Script:Resync = "True - Event's not detected"
            Write-Debug "`$Script:Resync is: $Script:Resync"
        }
    }
    Elseif($Script:WindowsTimeServiceStatus[0] -like "Leap Indicator: 1*")
    {
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        Write-Verbose "Windows Time Service Leap Indicator validated as 1. Syncoization failed."
        Write-Host "WTS Leap Indicator Code not defined. Resync attempt failed."
        Write-Error "Windows Time Service Leap Indictor status was validated as 1 and is not a known status within this command."
        $Script:WTSStatus = '1'
        $Script:Resync = 'True - Resync Failed'
        Write-Debug "`$Script:WTSStatus is: $Script:WTSStatus"
        Write-Debug "`$Script:Resync is: $Script:Resync"
    }
    Elseif($Script:WindowsTimeServiceStatus[0] -like "Leap Indicator: 3*")
    {
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        Write-Verbose "Windows Time Service Leap Indicator validated as 3. Syncoization failed."
        Write-Host "WTS Leap Indicator Code defined as 3. Resync attempt failed and may need to be reattempted."
        Write-Error "Windows Time Service Leap Indictor status was validated as 3. Command may need to me tried again."
        $Script:WTSStatus = '3'
        $Script:Resync = 'True - Resync Failed'
        Write-Debug "`$Script:WTSStatus is: $Script:WTSStatus"
        Write-Debug "`$Script:Resync is: $Script:Resync"       
    }
    else
    {
        Write-Debug "`$Script:WindowsTimeServiceStatus[0] is: $Script:WindowsTimeServiceStatus[0]"
        Write-Verbose "Windows Time Service Leap Indicator validated as a unknown status. Syncoization failed."
        Write-Host "'"'$WindowsTimeServiceStatus[0]'"' not defined. Resync attempt failed."
        Write-Error "Windows Time Service Leap Indictor status was validated as a unknown status error indicator."
        $Script:WTSStatus = 'Unknown'
        $Script:Resync = 'True - Resync Failed'
        Write-Debug "`$Script:WTSStatus is: $Script:WTSStatus"
        Write-Debug "`$Script:Resync is: $Script:Resync"
    }

}
#endregion