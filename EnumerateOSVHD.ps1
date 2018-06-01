$vmlist = get-azurermvm
$disklist = @()

foreach( $vm in $vmlist)
{

    $osvhd = $vm[0].StorageProfile.OsDisk.Vhd.Uri
    $m = $osvhd -match "//(.*)\.blob.*/(.*)/(.*)"
    $an = $matches[1]
    $cn = $matches[2]
    $bn = $matches[3]

    $acct = Get-AzureRmStorageAccount | where StorageAccountName -eq $an

    $key = Get-AzureRmStorageAccountKey -ResourceGroupName $acct[0].ResourceGroupName -Name $an
    $ctx = New-AzureStorageContext -StorageAccountName $an -StorageAccountKey $key.key1

    $blob = Get-AzureStorageBlob -Container $cn -Context $ctx -Blob $bn

    $blobSizeInBytes = 0
    $blob[0].ICloudBlob.GetPageRanges() | ForEach-Object { $blobSizeInBytes += $_.EndOffset - $_.StartOffset }

    $disk  = new-object psobject 
    $disk | Add-Member -Name VM -Value $vm.Name -MemberType NoteProperty
    $disk | Add-Member -Name Account   -Value $an -MemberType NoteProperty
    $disk | Add-Member -Name Container -Value $cn -MemberType NoteProperty
    $disk | Add-Member -Name Blob      -Value $bn -MemberType NoteProperty
    $disk | Add-Member -Name SizeB     -Value $blob[0].ICloudBlob.Properties.Length -MemberType NoteProperty
    $disk | Add-Member -Name SizeGiB   -Value ([math]::Round( ($blob[0].ICloudBlob.Properties.Length / 1GB ), 2 )) -MemberType NoteProperty
    $disk | Add-Member -Name UsedB     -Value $blobSizeInBytes -MemberType NoteProperty
    $disk | Add-Member -Name UsedGiB   -Value ([math]::Round( ($blobSizeInBytes / 1GB ), 2 )) -MemberType NoteProperty
    $disk | Add-Member -Name Sparse    -Value "unknown"  -MemberType NoteProperty
    if( [math]::abs($disk.SizeB - $disk.UsedB ) -lt 1024 ) { $disk.Sparse = $false } else { $disk.Sparse = $true }
    $disk | Add-Member -Name OSDiskUri -Value $osvhd -MemberType NoteProperty

    $disklist += @($disk)
}

$disklist