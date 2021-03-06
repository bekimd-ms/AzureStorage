Param(
  [string] $rg,
  [string] $acct, 
  [string] $container = ""
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1
$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 3

$blob = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

if( $container -eq "" )
{

  $container = -join(Get-Random $chars -Count (get-random -min 6 -max 48))
  $container = "tcnt" + $container 
  Write-Host "Creating container " $container
  New-AzureStorageContainer -Name $container -Context $ctx
}


$container + "/" + $blob

Set-AzureStorageBlobContent -Container $container -File ".\storagetools\content.txt" -Blob $blob -Context $ctx
