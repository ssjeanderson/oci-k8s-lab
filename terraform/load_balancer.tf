resource "oci_network_load_balancer_network_load_balancer" "k8slab_nlb" {
    compartment_id = oci_identity_compartment.k8slab_compartment.id
    display_name = "k8s-lab Network Load Balancer"
    subnet_id = oci_core_subnet.k8slab_subnet.id
    is_private = "false"
    network_security_group_ids = [oci_core_network_security_group.network_security_group_nlb.id]
}

resource "oci_network_load_balancer_backend_set" "k8slab_backend_set_http" {
    health_checker {
        protocol = "HTTP"
        port = "30080"
        return_code = "404"
    }
    name = "k8s-lab_NLB_Cluster_Backend_Set_HTTP"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8slab_nlb.id
    policy = "FIVE_TUPLE"
    is_preserve_source = false
}

resource "oci_network_load_balancer_backend" "instance_backend_http" {
    count = 3
    backend_set_name = oci_network_load_balancer_backend_set.k8slab_backend_set_http.name
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8slab_nlb.id
    port = "30080"
    name = oci_core_instance.k8slab_instance[count.index + 1].display_name
    target_id = oci_core_instance.k8slab_instance[count.index + 1].id
}

resource "oci_network_load_balancer_listener" "k8slab_listener_http" {
    default_backend_set_name = oci_network_load_balancer_backend_set.k8slab_backend_set_http.name
    name = "k8s-lab_NLB_Listener_HTTP"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8slab_nlb.id
    port = "80"
    protocol = "TCP"
}

# HTTPS Stuff

resource "oci_network_load_balancer_backend_set" "k8slab_backend_set_https" {
    health_checker {
        protocol = "HTTP"
        port = "30080"
        return_code = "404"
    }
    name = "k8s-lab_NLB_Cluster_Backend_Set_HTTPS"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8slab_nlb.id
    policy = "FIVE_TUPLE"
    is_preserve_source = false
}

resource "oci_network_load_balancer_backend" "instance_backend_https" {
    count = 3
    backend_set_name = oci_network_load_balancer_backend_set.k8slab_backend_set_https.name
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8slab_nlb.id
    port = "30443"
    name = "${oci_core_instance.k8slab_instance[count.index + 1].display_name}-https"
    target_id = oci_core_instance.k8slab_instance[count.index + 1].id
}

resource "oci_network_load_balancer_listener" "k8slab_listener_https" {
    default_backend_set_name = oci_network_load_balancer_backend_set.k8slab_backend_set_https.name
    name = "k8s-lab_NLB_Listener_HTTPS"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8slab_nlb.id
    port = "443"
    protocol = "TCP"
}