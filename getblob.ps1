param(
  [string] $rg,
  [string] $acct,
  [string] $cont
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1

$blobs = Get-AzureStorageBlob -Container $cont -Context $ctx 

foreach( $blob in $blobs )
{
   $blob
   $blob.ICloudBlob.Properties
}
