terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
    }
  }
}

provider "oci" {
   tenancy_ocid = "${var.tenancy_ocid}"
   user_ocid = "${var.user_ocid}"
   fingerprint = "${var.fingerprint}"
   private_key_path = "${var.private_key_path}"
   region = "${var.region}"
}

resource "oci_identity_compartment" "k8slab_compartment" {
    #Required
    compartment_id = var.root_compartment_ocid
    description = "k8s-lab Compartment"
    name = "k8s-lab"

    #Optional
    enable_delete = true
}