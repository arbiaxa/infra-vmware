
ssh  admin@172.16.10.137 

'config firewall address
    edit "fortigate-subnet"
        set type subnet
        set interface "port3"
        set subnet 192.168.100.0 255.255.255.0
    next
end


config firewall policy
     edit 0
         set name "Allow_FG_To_Internet"
         set srcintf "port3"
         set dstintf "port1"
         set srcaddr "fortigate-subnet"
         set dstaddr "all"
         set action accept
         set schedule "always"
         set service "ALL"
         set nat enable
    next
end
'

