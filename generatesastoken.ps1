$resgroup = "backup" 
$account = "sqlbackup" 
$container = "backup"

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $resgroup -StorageAccountName $account
$ctx = New-AzureStorageContext -StorageAccountName $account -StorageAccountKey $key.Key1
Remove-AzureStorageContainerStoredAccessPolicy -Container $container -Policy BackupPolicy -Context $ctx
$policy = New-AzureStorageContainerStoredAccessPolicy -Container $container -Policy BackupPolicy -Permission "rwld" -Context $ctx
$token = New-AzureStorageContainerSASToken -Name $container -Policy $policy -StartTime $(Get-Date).ToUniversalTime().AddMinutes(-5) -ExpiryTime $(Get-Date).ToUniversalTime().AddYears(10) -Context $ctx

$token
$sasctx = New-AzureStorageContext -StorageAccountName $account -SasToken $token
get-azurestorageblob -Container $container -Context $sasctx


