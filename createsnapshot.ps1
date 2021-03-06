param(
  [string] $rg,
  [string] $acct,
  [string] $container,
  [string] $blobname 
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1
$blob = Get-AzureStorageBlob -Context $Ctx -Container $container -Blob $blobname

$snap = $blob.ICloudBlob.CreateSnapshot()

$snap

