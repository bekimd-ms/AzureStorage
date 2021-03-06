Param(
  [string] $rg,
  [string] $acct, 
  [string] $container, 
  [string] $blob
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1
Get-AzureStorageBlobContent -Container $container -Blob $blob -Context $ctx -Destination .
