$vdisklist = Get-VirtualDisk

$volumelist = @()
foreach( $vdisk in $vdisklist )
{
    $disk = get-disk -VirtualDisk $vdisk
    $partition = (get-partition -Disk $disk)[1]
    $volume = Get-Volume -Partition $partition
    $csv = Get-ClusterSharedVolume -Name ("Cluster Virtual Disk (" + $volume.FileSystemLabel + ")")


    $xvolume = [pscustomobject][ordered] @{ `
                    vdName = $vdisk.FriendlyName; `
                    csvPath = $csv.SharedVolumeInfo.FriendlyVolumeName; `
                    vdHealth = $vdisk.HealthStatus; `
                    vdStatus = $vdisk.OperationalStatus; `
                    vdDetach = $vdisk.DetachedReason; `
                    vdUsage = $vdisk.Usage; `
                    dHealth = $disk.HealthStatus; 
                    dStatus = $disk.OperationalStatus;
                    vHealth = $volume.HealthStatus; `
                    vStatus = $volume.OperationalStatus; `
                    csvFault = $csv.SharedVolumeInfo.FaultState; `
                    csvState = $csv.State; `
                    csvOwner = $csv.OwnerNode; `
                    pStatus = $partition.OperationalStatus; `
                    `
                    dAllocated = ($disk.AllocatedSize / 1GB ); `
                    dSize = ($disk.Size / 1GB ); `
                    vdAllocated = ($vdisk.AllocatedSize / 1GB ); `
                    vdSize = ( $vdisk.Size / 1GB ); `
                    vSize = ( $volume.Size / 1GB ); `
                    vRemaining = ( $volume.SizeRemaining / 1GB ); `
                    `
                    vdisk = $vdisk; `
                    disk = $vdisk; `
                    partition = $partition; `
                    volume = $volume; `
                    csv = $csv }

    $volumelist += @($xvolume)
    
}

$volumelist | sort vdName


