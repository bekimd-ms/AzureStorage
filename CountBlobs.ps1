param(
  [string] $sub = "",
  [string] $rg,
  [string] $acct = "",
  [string] $cont = ""
)


if( $sub -ne "" )
{
    Write-Host "Select subscription " $sub
    $subobj = Select-AzureRmSubscription -SubscriptionName $sub 
}

if( $acct -eq "" )
{
    $acct = $rg
}


function CountBlobs( $container, $ctx )
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
    $blobcounts = new-object psobject -Property @{ Name=$container.Name; Count=$count; Size=$size }
    $blobcounts
} 

Write-Host "Resrouce Group " $rg " Account " $acct
$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $acct
$ctx = New-AzureStorageContext -StorageAccountName $acct -StorageAccountKey $key.Key1


$blobcnt = 0
$blobsize = 0
$continfo = @()

if( $cont -eq "")
{
    $containers = Get-AzureStorageContainer  -Context $ctx
    foreach( $container in $containers )  
    {
        $blobcounts = CountBlobs $container $ctx
        $blobcnt  = $blobcnt + $blobcounts.Count
        $blobsize = $blobsize + $blobcounts.Size  
        $continfo += new-object psobject -Property @{ Name=$container.Name; Count=$blobcounts.Count; Size=$blobcounts.Size} 
    }

    #$continfo | select Name, Count, Size | format-table
    $totalinfo = new-object psobject -Property @{ Sub=$sub; Rg=$rg; Acct=$acct; Cont=""; Count=$blobcnt; Size=$blobsize } 
}
else
{
    $container = Get-AzureStorageContainer  -Context $ctx -Name $cont
    $totalinfo += new-object psobject -Property @{ Sub=$sub; Rg=$rg; Acct=$acct; Cont=$container.Name; Count=$blobcnt; Size=$blobsize } 
}

$totalinfo