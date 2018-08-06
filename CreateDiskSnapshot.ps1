param(
  [string] $rg,
  [string] $diskName,
  [string] $snaprg,
  [string] $snapId
)


$resourcegroup = Get-AzureRmResourceGroup $snaprg

$disk = Get-AzureRmDisk -ResourceGroupName $rg -DiskName $diskName

$snapshot =  New-AzureRmSnapshotConfig `
                -SourceUri $disk.id `
                -Location $resourcegroup.Location `
                -CreateOption copy

New-AzureRmSnapshot `
                -Snapshot $snapshot `
                -SnapshotName ( $diskName + "-" + $snapId) `
                -ResourceGroupName $snaprg

