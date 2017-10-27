param(
  [string] $rg,
  [string] $acct,
  [string] $cont = "auto"
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1


$blobcnt = 0
$blobsize = 0
$continfo = @()

if( $cont -eq "auto")
{
    $containers = Get-AzureStorageContainer  -Context $ctx
    foreach( $container in $containers )  
    {
        $size = 0
        $count = 0
        $token = $null
        do
        {
            $blobs = Get-AzureStorageBlob -Container $container.Name -Context $ctx -ContinuationToken $token
            if( $blobs.Count -le 0 ) { break }
            $size += (($blobs | Measure-Object -Sum Length).Sum)
            $count += $blobs.Count
            $Token = $Blobs[$blobs.Count-1].ContinuationToken
        }
        While ($Token -ne $Null)
        $blobcnt = $blobcnt + $count
        $blobsize = $blobsize + $size 
        $continfo += new-object psobject -Property @{ Name=$container.Name; Count=$count; Size=([math]::Round($size/1GB,2))} 
    }

    $continfo | select Name, Count, Size | format-table
    Write-Host ""
    Write-Host "TOTAL  " $blobcnt ([math]::Round($blobsize/1GB,2))
}
else
{
    $container = Get-AzureStorageContainer  -Context $ctx -Name $cont
    Write-Host $container
}
