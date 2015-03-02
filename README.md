Puppet Module
=================

Module for configuring OpenBSD networking.

Tested on OpenBSD 4.9 and 5.0 
Puppet 2.7.5

TODO
----

* Tun devices 

Installation
------------
Clone this repo to a git directory under your Puppet modules directory:

    git clone git@github.com:nicksu100/puppet-openbsd-network.git openbsd-network

Usage
-----

The physical interface should be called as a virtual resource. The following example
would add a physical interface em0 and a vlan tagged interface using bnx1 for
vlan 2 vlan 3 against bnx1 with 2 carped interfaces. 
```puppet
node test { 
  #Physical interface
	include openbsd-network::physical_interface
        	@openbsd-network::physical_interface::localphysicalinterface {"${hostname}externalphydev":
           	interface => "em0",
                address => "10.1.0.2",
           	netmask => "255.255.255.0",
          	broadcast => "10.1.0.255",
           	physical_aliasip => "",
          }

 	     realize(Openbsd-network::Physical_interface::Localphysicalinterface["${hostname}externalphydev"])

#Create vlan devices
        @openbsd-network::create_vlan_interface::localvlandevice {"${hostname}internalvlandev":
            vlan_dev => "bnx1",
             }
      realize(Openbsd-network::Create_vlan_interface::Localvlandevice["${hostname}internalvlandev"])

#Configure internal vlan for private network
   	include openbsd-network::vlan_interface
      	  @openbsd-network::vlan_interface::localvlan { "${hostname}vlan2":
                interface =>   "vlan2",
          	vlan_address => "192.168.2.2",
        	vlan_netmask => "255.255.255.0",
                vlan_tag     => "2",
                vlan_dev     => "bnx1",
          }

#Configure internal vlan for phone network
 	@openbsd-network::vlan_interface::localvlan { "${hostname}vlan3":
          	interface =>   $phone_vlan_if,
          	vlan_address => "10.1.20.2",
          	vlan_netmask => "255.255.255.0",
          	vlan_tag     => "3",
          	vlan_dev     => "bnx1",
        }  
 realize(Openbsd-network::Vlan_interface::Localvlan["${hostname}vlan2"],
            Openbsd-network::Vlan_interface::Localvlan["${hostname}vlan3"])

include openbsd-network::carp_interface

       @openbsd-network::carp_interface::localcarpdev {"${hostname}carp2":
           interface => "carp2",
           carp_address => "192.168.2.1",
           carp_netmask => "255.255.255.0",
           carp_vhid => "1",
           carp_pass => "changeme",
           carp_advbase => "1",
           carp_advskew => "0",
           carp_dev => "vlan2",
           carp_peer => "192.168.2.3",
           carp_aliasip =>[],
         }

       @openbsd-network::carp_interface::localcarpdev {"${hostname}carp3":
           interface => "carp3",
           carp_address => "10.1.20.1",
           carp_netmask => "255.255.255.0",
           carp_vhid => "2",
           carp_pass => "changeme",
           carp_advbase => "2",
           carp_advskew => "0",
           carp_dev => "vlan3",
           carp_peer => "10.1.20.3",
           carp_aliasip => $my_local_carp1_alias,
         }
   
      realize(Openbsd-network::Carp_interface::Localcarpdev["${hostname}carp2"],
             Openbsd-network::Carp_interface::Localcarpdev["${hostname}carp3"])

# Create physical interface for our pfsync
    @openbsd-network::physical_interface::localphysicalinterface {"${hostname}pfsync0":
           interface => "em7",
           address => "192.168.50.2",
           netmask => "255.255.255.0",
           broadcast => "192.168.50.255",
           physical_aliasip => "",
          }

      realize(Openbsd-network::Physical_interface::Localphysicalinterface["${hostname}pfsync0"],

# Should only have one pfsync device so called only once
 class { "openbsd-network::pfsync_interface": interface => "pfsync0",
          pfsync_dev     => "em7",
          pfsync_peer    => "192.168.50.3"
      }

```
