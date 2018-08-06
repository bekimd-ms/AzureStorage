$sp = get-storagepool -FriendlyName "S2D on s2dclu-s2d-c"
write-host "Allocated: " ( $sp.AllocatedSize / 1GB )
write-host "Size:      " ( $sp.Size / 1GB )