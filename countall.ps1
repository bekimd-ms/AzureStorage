$totalcount = @()

$accounts = @(
    [pscustomobject]@{sub="sub4";info="datavol1"},
    [pscustomobject]@{sub="sub7";info="datavol7"},
    [pscustomobject]@{sub="sub8";info="datavol8"},
    [pscustomobject]@{sub="sub11";info="datavol11"},
    [pscustomobject]@{sub="sub12";info="datavol12"},
    [pscustomobject]@{sub="sub13";info="datavol13"}
)

foreach( $account in $accounts )
{
    $totalcount += @(.\storagetools\CountBlobs.ps1 -sub $account.sub  -rg $account.info)
}

$totalcount | select Rg, Sub, Count, @{Name="GB";Expression={[math]::Round($_.Size/1GB,2)}}