param(
    [string] $saspath
  )


$uri = [uri] $saspath
$path = "{0}{1}{2}{3}" -f $uri.Scheme,[uri]::SchemeDelimiter,$uri.Authority,$uri.AbsolutePath
$cred = New-Object Microsoft.WindowsAzure.Storage.Auth.StorageCredentials -ArgumentList $uri.Query
$blobClient = New-Object Microsoft.WindowsAzure.Storage.Blob.CloudBlobClient -ArgumentList $path,$cred
$pageblob = [Microsoft.WindowsAzure.Storage.Blob.CloudPageBlob]($blobClient.GetBlobReferenceFromServer($path))
$pageranges = $pageblob.GetPageRanges()

$blobSizeInBytes = 0
$pageranges | ForEach-Object { `
        $bytes = $_.EndOffset - $_.StartOffset; `
        Write-Host $_.StartOffset "-" $_.EndOffset ": " ([math]::Round(($bytes / 1024),2)) "KiB"; `
        $blobSizeInBytes += $bytes }


Write-Host ""
Write-Host "Used:     " $blobSizeInBytes "B " ([math]::Round( ($blobSizeInBytes / (1024 * 1024 * 1024 )), 2 )) "GiB" 
Write-Host "Page range count: " (($pageranges | measure).Count)


