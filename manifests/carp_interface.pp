#
# Class: openbsd-network::carp_interface
#
# Manages OpenBSD carped interfaces
#

class openbsd-network::carp_interface {
     define localcarpdev (
       $interface, 
       $carp_address, 
       $carp_netmask, 
       $carp_broadcast = "NONE",  
       $carp_vhid,
       $carp_pass,
       $carp_advbase,
       $carp_advskew,
       $carp_dev,
       $carp_peer,
       $carp_aliasip ) 
       
 {
include openbsd-network::restart
     file { "/etc/hostname.${interface}":
         content => template("openbsd-network/carp_interface.erb"),
         owner => root,
         group => wheel,
         mode => 640,
         notify => Exec[net_start]
         }

  }
}
