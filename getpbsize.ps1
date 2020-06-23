param(
  [string] $rg,
  [string] $an,
  [string] $cn,
  [string] $bn
)

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rg -Name $an
$ctx = New-AzureStorageContext -StorageAccountName $an -StorageAccountKey $key[0].Value

$blob = Get-AzureStorageBlob -Container $cn -Context $ctx -Blob $bn

Write-Host "Blob:     " $blob[0].ICloudBlob.Uri.AbsoluteUri
Write-Host "Type:     " $blob[0].ICloudBlob.BlobType
Write-Host "Length:   " $blob[0].ICloudBlob.Properties.Length "B " ([math]::Round( ($blob[0].ICloudBlob.Properties.Length / (1024 * 1024 * 1024 )), 2 )) "GiB"

$pageranges = $blob.ICloudBlob.GetPageRanges()
$blobSizeInBytes = 0
$pageranges | ForEach-Object { `
  $bytes = $_.EndOffset - $_.StartOffset; `
  Write-Host $_.StartOffset "-" $_.EndOffset ": " ([math]::Round(($bytes / 1024),2)) "KiB"; `
  $blobSizeInBytes += $bytes }


Write-Host ""
Write-Host "Used:     " $blobSizeInBytes "B " ([math]::Round( ($blobSizeInBytes / (1024 * 1024 * 1024 )), 2 )) "GiB" 
Write-Host "Page range count: " (($pageranges | measure).Count)


#$pageRangesSegSize = 148 * 1024 * 1024L
#$totalSize = $Blob.ICloudBlob.Properties.Length
#$pageRangeSegOffset = 0

#$pageRangesTemp = New-Object System.Collections.ArrayList

#while ($pageRangeSegOffset -lt $totalSize)
#{
#  $pages = $Blob[0].ICloudBlob.GetPageRanges($pageRangeSegOffset, $pageRangesSegSize) 
#
#  $pages | ForEach-Object { $pageRangesTemp.Add($_) }  
  
#  $pageRangeSegOffset += $pageRangesSegSize
#
#}

#$pageRangesTemp




