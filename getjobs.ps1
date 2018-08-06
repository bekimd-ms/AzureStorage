$vdisklist = Get-VirtualDisk

$joblist = @()
foreach( $vdisk in  $vdisklist )
{
    $jobs = Get-StorageJob -VirtualDisk $vdisk
    
    foreach( $job in $jobs )
    {
        $xjob = [pscustomobject][ordered] @{ `
                        vdisk = $vdisk.FriendlyName; `
                        name = $job.Name;
                        state = $job.JobState; 
                        progress = $job.PercentComplete;
                        time = $job.ElapsedTime;
                        background = $job.IsBackgroundTask;
                        processed = ( $job.BytesProcessed / 1GB ); `
                        total = ( $job.BytesTotal / 1GB ); `
                        id = $job.UniqueId; `
                  } 
        $joblist += @($xjob)
    }
    
}

foreach( $job in ( get-storagejob | where Name -in ("Rebalance","Optimize") ) )
{
       $xjob = [pscustomobject][ordered] @{ `
                        vdisk = ""; `
                        name = $job.Name;
                        state = $job.JobState; 
                        progress = $job.PercentComplete;
                        time = $job.ElapsedTime;
                        background = $job.IsBackgroundTask;
                        processed = ( $job.BytesProcessed / 1GB ); `
                        total = ( $job.BytesTotal / 1GB ); `
                        id = $job.UniqueId; `
                  } 
        $joblist += @($xjob)
}

$joblist | sort vdisk



