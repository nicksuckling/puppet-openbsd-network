#Use this to delete an existing network that we want to become a vlan 
class openbsd-network::delete_vlan_interface {
     exec { "delete_network":
        command => "/sbin/ifconfig ${vlan_dev} delete",
        onlyif => "test -n $network_${vlan_dev}" ,
        refreshonly => true,
        } 
}
