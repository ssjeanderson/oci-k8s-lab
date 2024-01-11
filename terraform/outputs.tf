output "instance_private_ip" {
	description = "Lists private ip address by instance"
	value = [ for i in oci_core_instance.k8slab_instance: "${i.display_name} - ${i.public_ip} - ${i.private_ip}" ]
}

output "network_load_balancer_public_ip" {
	description = "IP public for network load balancer"
	value = oci_network_load_balancer_network_load_balancer.k8slab_nlb.ip_addresses[0].ip_address
}

resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl",
    {
			instance = oci_core_instance.k8slab_instance[*],
    }
  )
  filename = "../inventory"
}

