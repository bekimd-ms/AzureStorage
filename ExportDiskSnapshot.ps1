param(
  [string] $rg,
  [string] $sn,
  [string] $acctrg,
  [string] $acct,
  [string] $cont
)

$sas = Grant-AzureRmSnapshotAccess -ResourceGroupName $rg -SnapshotName $sn -DurationInSecond 3600 -Access Read

Write-Output $sas 
$key = Get-AzureRmStorageAccountKey -ResourceGroupName $acctrg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key[0].Value

#Copy the snapshot to the storage account 
Start-AzureStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $cont  -DestContext $ctx -DestBlob $sn

