param(
  [string] $rg,
  [string] $diskName,
  [string] $snapId
)


$resourcegroup = Get-AzureRmResourceGroup $rg

$disk = Get-AzureRmDisk -ResourceGroupName $rg -DiskName $diskName

$snapshot =  New-AzureRmSnapshotConfig `
                -SourceUri $disk.id `
                -Location $resourcegroup.Location `
                -CreateOption copy

Measure-Command -Expression { `
New-AzureRmSnapshot `
                -Snapshot $snapshot `
                -SnapshotName ( $diskName + "-" + $snapId) `
                -ResourceGroupName $rg }

