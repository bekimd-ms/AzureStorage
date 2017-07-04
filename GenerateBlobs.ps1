param(
  [string] $rg,
  [string] $acct,
  [string] $cont = ""
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1
$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 3

while( 1 -eq 1 )
{

  $order = get-random -min 0 -max 3
  $min = [math]::pow(10,$order)
  $max = [math]::pow(10,$order+1)
  $cnt = get-random -min $min -max $max
  $cnt = [math]::round($cnt)

  if( $cont -eq "" )
  {
     $container = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

     New-AzureStorageContainer -Name $container -Permission Off -Context $ctx
  }
  else 
  {
     $container = $cont
  }

  for ($i=1; $i -lt $cnt; $i++) 
  {      
     $blob = -join(Get-Random $chars -Count (get-random -min 6 -max 48))
     $blobSize = Get-Random -min 0 -max 5
     $blob = "b" + $blobSize + $blob
     $blobSource = ".\storagetools\content" + $blobSize + ".txt"
     $container + "/" + $blob
     Set-AzureStorageBlobContent -Container $container -File $blobSource -Blob $blob -Context $ctx
  }

}