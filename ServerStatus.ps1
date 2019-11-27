#this Script pings servers from a list , input file , and also resolves DNS for these servers

$servers = Get-Content C:\temp\servers.txt


$collection = $()
foreach ($server in $servers)
{
    $status = @{ "ServerName" = $server; "TimeStamp" = (Get-Date -f s) ;}
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
        $status["Results"] = "Up"
        $ErrorActionPreference = "silentlycontinue"
        $result = $null
        $result = [System.Net.Dns]::gethostentry($server)
       
       If ($Result) { 
       #$status["DNS"] = [System.Net.Dns]::gethostentry($server) 
       $status["DNS"] = [string]$Result.HostName
       }
        Else    {         $status["DNS"] = "UnableToResolve"        }       

    } 
    else 
    { 
        $status["Results"] = "Down" 
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus

}
$collection | Export-Csv C:\temp\ServerStatus.csv -NoTypeInformation
