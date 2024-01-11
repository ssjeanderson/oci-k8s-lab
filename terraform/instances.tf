
resource "oci_core_instance" "k8slab_instance" {
  count = 4
	agent_config {
		is_management_disabled = "true"
		is_monitoring_disabled = "false"
		plugins_config {
			desired_state = "DISABLED"
			name = "Vulnerability Scanning"
		}
		plugins_config {
			desired_state = "ENABLED"
			name = "Compute Instance Monitoring"
		}
		plugins_config {
			desired_state = "DISABLED"
			name = "Bastion"
		}
	}
	availability_config {
		recovery_action = "RESTORE_INSTANCE"
	}
	availability_domain = "CjRk:SA-SAOPAULO-1-AD-1"
	compartment_id = oci_identity_compartment.k8slab_compartment.id
	create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "true"
		skip_source_dest_check = "true"
		subnet_id = oci_core_subnet.k8slab_subnet.id
	}
	display_name = "k8slab_instance-${count.index}"
	instance_options {
		are_legacy_imds_endpoints_disabled = "false"
	}
	is_pv_encryption_in_transit_enabled = "true"
	metadata = {
		"ssh_authorized_keys" = file(var.ssh_public_key_path)
	}
	shape = "VM.Standard.A1.Flex"
	shape_config {
		memory_in_gbs = "6"
		ocpus = "1"
	}
	source_details {
		source_id = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaovmgmjdepm5x372pzvkq7nuwhwt3vaiexr3wfweyozl2br5e6wsq"
		source_type = "image"
	}
}
