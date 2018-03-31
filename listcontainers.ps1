$tablelist = @()
$salist = Get-AzureRMStorageAccount 
foreach( $sa in $salist )
{
    
    $key = Get-AzureRmStorageAccountKey -ResourceGroupName $sa.ResourceGroupName -Name $sa.StorageAccountName
    $ctx = New-AzureStorageContext -StorageAccountName $sa.StorageAccountName -StorageAccountKey $key.Key1

    $tablelistadd = get-azurestoragetable -Context $ctx
    foreach( $table in $tablelistadd )
    {
        Write-Output ($sa.ResourceGroupName + "," + $sa.StorageAccountName + "," + $table.Name )
    }

}

$tablelist
