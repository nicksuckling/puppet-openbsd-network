class openbsd-network::physical_interface {
     define localphysicalinterface (
       $interface,
       $address,
       $netmask,
       $broadcast,
       $physical_aliasip )

 {
include openbsd-network::restart

     file { "/etc/hostname.${interface}":
         owner => root,
         group => wheel,
         mode => 640,
         content => template("openbsd-network/physical_interface.erb"),
         notify => Exec[net_start]
         }

  }
}

class openbsd-network::default_gw {
       define gw (
         $my_default_gw ) 
{
file { "/etc/mygate": 
         content => template ("openbsd-network/default_gw.erb"),
         owner => root,
         group => wheel,
         mode => 640,
         ensure => present,
         notify => Exec[change_default_gw]
         }

    exec { "change_default_gw":
        command => "echo 'This host should be checked as the default gw has changed' | mail -s 'Network default gw change: restart ${fqdn}' root",
        refreshonly => true,
    }
 } 
}
