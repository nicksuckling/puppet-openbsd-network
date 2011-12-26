# 
# Class: openbsd-network::restart
#
#Manage OpenBSD network restart using /etc/netstart
#
#Usage:
# include network::restart
#
class openbsd-network::restart {
   exec { "net_start":
                command => '/bin/sh /etc/netstart $interface ',
                refreshonly => true,
        }
} 
