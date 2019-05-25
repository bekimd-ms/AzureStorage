param(
  [string] $rg,
  [string] $acct
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key[0].Value

$ctx