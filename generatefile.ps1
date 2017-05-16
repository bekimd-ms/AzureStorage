$chars = [char[]] ([char]'0'..[char]'9' + [char]'a'..[char]'z')
$chars = $chars * 30

function GenerateContent
{

   $content = -join(Get-Random $chars -Count 512)
   Write-Host $content.Length	   

   for($i=1; $i -lt 512; $i++)
   {
      $content = -join($content, -join( Get-Random $chars -Count 512))
      Write-Host $i, $content.Length
   }

   $content
}

GenerateContent | Out-File -FilePath testfile.txt