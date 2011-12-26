#
# Class: openbsd-network::pfsync_interface
#
# Manages OpenBSD pfsync interface 
#



class openbsd-network::pfsync_interface(
       $interface, 
       $pfsync_dev,
       $pfsync_peer ) 
 {
include openbsd-network::restart

     file { "/etc/hostname.${interface}":
         owner => root,
         group => wheel,
         mode => 640,
         content => template("openbsd-network/pfsync_interface.erb"),
         notify => Exec[net_start]
         }

  }
