param(
  [string] $rg,
  [string] $acct,
  [string] $cont
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1

$cnt = Get-AzureStorageContainer -Name $cont -Context $ctx 

$cnt
$cnt.CloudBlobContainer.Properties