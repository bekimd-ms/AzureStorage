
$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 30
$targetratio = .95
Write-Host "Target ratio ", $targetratio



function GetFreeRatio( $csv )
{
  $ratio = 1 - $csv.SharedVolumeInfo.Partition.PercentFree/100
  $ratio
}


function GenerateContent
{
   $content = -join(Get-Random $chars -Count 512)

   for($i=1; $i -lt 512; $i++)
   {
      $content = -join($content, -join( Get-Random $chars -Count 512))
   }

   $content
}

$content = GenerateContent
while( $true )
{

    $order = get-random -min 3 -max 5
    $min = [math]::pow(10,$order)
    $max = [math]::pow(10,$order+1)
    $cnt = get-random -min $min -max $max
    $cnt = [math]::round($cnt)


    $folderName = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

    for ($i=1; $i -lt $cnt; $i++) 
    {     

        $file = -join(Get-Random $chars -Count (get-random -min 6 -max 48))

        $size = (get-random -min 10 -max 1000)
        $sizegb = ($size * $content.Length)/(1024*1024*1024)
        Write-Host $sizegb, $file

        for($i=1; $i -lt $size; $i++)
        {
            $content | Out-file -FilePath $file -Append
        }


        foreach( $csv in get-clustersharedvolume )
        {
            if( GetFreeRatio( $csv ) -lt $targetratio )
            {

                $folder = $csv.SharedVolumeInfo.FriendlyVolumeName + "\" + $folderName
                if( -not (test-path $folder) )
                {
                   mkdir $folder
                }
                copy $file $folder
            }
        }
        del $file
    }
  
}




