param(
  [string] $rg,
  [string] $an,
  [string] $cn,
  [string] $bn
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $an
$ctx = New-AzureStorageContext -StorageAccountName $an -StorageAccountKey $key.Key1

$blob = Get-AzureStorageBlob -Container $cn -Context $ctx -Blob $bn

Write-Host "Blob:     " $blob[0].ICloudBlob.Uri.AbsoluteUri
Write-Host "Type:     " $blob[0].ICloudBlob.BlobType
Write-Host "Length:   " $blob[0].ICloudBlob.Properties.Length "B " ([math]::Round( ($blob[0].ICloudBlob.Properties.Length / (1024 * 1024 * 1024 )), 2 )) "GiB"

$blobSizeInBytes = 0
$blob[0].ICloudBlob.GetPageRanges() | ForEach-Object { $blobSizeInBytes += 12 + $_.EndOffset - $_.StartOffset }

Write-Host "USed:     " $blobSizeInBytes "B  " ([math]::Round( ($blobSizeInBytes / (1024 * 1024 * 1024 )), 2 )) "GiB" 