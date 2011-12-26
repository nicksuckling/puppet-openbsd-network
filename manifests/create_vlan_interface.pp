#
# Class: network::vlan_interface
#
# Manages OpenBSD vlan interfaces
#

class openbsd-network::create_vlan_interface {
       define localvlandevice ( $vlan_dev ){
 include openbsd-network::restart
 include openbsd-network::delete_vlan_interface
     file { "/etc/hostname.${vlan_dev}":
         content => "up",
         owner => root,
         group => wheel,
         mode => 640,
         notify => Exec[delete_network, net_start]
         }
  }
}
