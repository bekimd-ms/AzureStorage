param(
  [string] $rg,
  [string] $acct,
  [string] $cont = "auto"
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1
$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 3

$contcnt = get-random -min 5 -max 20
$contcnt = [math]::round($contcnt)

if( $cont -eq "auto")
{
  Write-Host "Creating containers..."
  $containers = @()
  Write-Host $contcnt
  for( $i=0; $i -lt $contcnt; $i++  )
  {
      $container = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

      New-AzureStorageContainer -Name $container -Permission Off -Context $ctx
      
      $containers += @($container)
  }
}

Write-Host "Creating blobs"
$contix = 0

while( 1 -eq 1 )
{

  if( $cont -eq "auto" )
  {
     $container = $containers[$contix]
     $contix = ($contix + 1 ) % $contcnt
     Write-Host "Container id: " $contix
     $cnt = 1;
  }
  else 
  {
     $container = $cont
     $order = get-random -min 0 -max 3
     $min = [math]::pow(10,$order)
     $max = [math]::pow(10,$order+1)
     $cnt = get-random -min $min -max $max
     $cnt = [math]::round($cnt)        
  }

  for ($i=0; $i -lt $cnt; $i++) 
  {      
     $blob = -join(Get-Random $chars -Count (get-random -min 6 -max 48))
     $blobSize = Get-Random -min 0 -max 5
     $blob = "b" + $blobSize + $blob
     $blobSource = ".\storagetools\content" + $blobSize + ".txt"
     $container + "/" + $blob
     Set-AzureStorageBlobContent -Container $container -File $blobSource -Blob $blob -Context $ctx
  }

}