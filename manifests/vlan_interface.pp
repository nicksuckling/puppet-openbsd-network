#
# Class: openbsd-network::vlan_interface
#
# Manages OpenBSD vlan interface 
#
class openbsd-network::vlan_interface { 
      define localvlan ( 
       $interface, 
       $vlan_address, 
       $vlan_netmask, 
       $vlan_tag, 
       $vlan_dev ){
 
     include openbsd-network::restart
        file { "/etc/hostname.${interface}":
         content => template("openbsd-network/vlan_interface.erb"),
         owner => root,
         group => wheel,
         mode => 640,
         notify => Exec[net_start],
         }

     }  
  }
