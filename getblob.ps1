param(
  [string] $rg,
  [string] $acct,
  [string] $cont
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key[0].Value

$blobs = Get-AzureStorageBlob -Container $cont -Context $ctx 

$blobs
#$blob.ICloudBlob.Properties

