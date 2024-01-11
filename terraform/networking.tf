resource "oci_core_vcn" "k8slab_vcn" {
  dns_label      = "k8slabvcn"
  cidr_blocks     = ["10.99.0.0/16"]
  compartment_id = oci_identity_compartment.k8slab_compartment.id
  display_name   = "k8s-lab VCN"
}

resource "oci_core_default_route_table" "default_route_table" {
    #Required
    manage_default_resource_id = oci_core_vcn.k8slab_vcn.default_route_table_id
    route_rules {
        #Required
        network_entity_id = oci_core_internet_gateway.k8slab_ig.id

        #Optional
        description = "Default Route"
        destination = "0.0.0.0/0"
    }

}
resource "oci_core_subnet" "k8slab_subnet" {
  vcn_id                      = oci_core_vcn.k8slab_vcn.id
  cidr_block                  = "10.99.0.0/24"
  compartment_id              = oci_identity_compartment.k8slab_compartment.id
  display_name                = "k8s-lab Subnet"
  prohibit_public_ip_on_vnic  = false
  dns_label                   = "k8slabsubnet"
  route_table_id              = oci_core_vcn.k8slab_vcn.default_route_table_id
}

resource "oci_core_internet_gateway" "k8slab_ig" {
    #Required
    compartment_id = oci_identity_compartment.k8slab_compartment.id
    vcn_id = oci_core_vcn.k8slab_vcn.id

    #Optional
    display_name = "k8s-lab Internet Gateway"
    enabled = "true"
}

resource "oci_core_default_security_list" "default_security_list" {
  # Required
  manage_default_resource_id = oci_core_vcn.k8slab_vcn.default_security_list_id

  ingress_security_rules {
    description = "Allow subnet internal"
    protocol = "all"
    source   = oci_core_subnet.k8slab_subnet.cidr_block
  }

  ingress_security_rules {
    description = "Allow SSH Access from all"
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    description = "Allow k8s API access from all"
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 6443
      min = 6443
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_network_security_group" "network_security_group_nlb" {
    #Required
    compartment_id = oci_identity_compartment.k8slab_compartment.id
    vcn_id = oci_core_vcn.k8slab_vcn.id

    #Optional
    display_name = "HTTP/HTTPS_NLB_Traffic"
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_http" {
    #Required
    network_security_group_id = oci_core_network_security_group.network_security_group_nlb.id
    description = "Allow HTTP from Internet"
    protocol = "6"
    direction = "INGRESS"

    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
        destination_port_range {
            max = 80
            min = 80
        }
    }
}

resource "oci_core_network_security_group_security_rule" "network_security_group_security_rule_https" {
    #Required
    network_security_group_id = oci_core_network_security_group.network_security_group_nlb.id
    description = "Allow HTTPS from Internet"
    protocol = "6"
    direction = "INGRESS"

    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
        destination_port_range {
            max = 443
            min = 443
        }
    }
}