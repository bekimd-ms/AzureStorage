$nodelist = Get-StorageNode

$drivelist = @()
for( $i=1; $i -lt $nodelist.Count; $i++ )
{
    $node = $nodelist[$i]
    $drives = Get-PhysicalDisk -StorageNode $node -PhysicallyConnected
    
    foreach( $drive in $drives )
    {
        $xdrive = [pscustomobject][ordered] @{ `
                        node = $node.Name; `
                        id = $drive.DeviceId;
                        health = $drive.HealthStatus; 
                        status = $drive.OperationalStatus; 
                        usage = $drive.Usage; `
                        canpool = $drive.CanPool; `
                        reason = $drive.CannotPoolReason; `
                        bus = $drive.BusType; `
                        media = $drive.MediaType; `
                        location = $drive.PhysicalLocation; `
                        size = ( $drive.Size / 1GB ); `
                        allocated = ( $drive.AllocatedSize / 1GB ); `
                  } 
        $drivelist += @($xdrive)
    }
  
}

$drivelist | sort node, location


