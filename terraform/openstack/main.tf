terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.49.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name         = "<nazmi.ozcelik@tubitak.gov.tr>"
  tenant_name       = "<nazmi.ozcelik@tubitak.gov.tr>"
  tenant_id         = "<b3820ea588a447d8a90d55c59d0161be>"
  password          = "<OS_PASSWORD>"
  auth_url          = "<https://safivdfvfd.dvfvfv.org:5000>"
  region            = "<RegionOne>"
  user_domain_name  = "<Default>"
  project_domain_id = "<default>"
}

resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "floating_network"
}

resource "openstack_blockstorage_volume_v3" "volume_1" {
  name        = "volume1-test-server"
  description = "first test volume"
  size        = 20                      # volume size in GB
  image_id    = "<0037e199-3e47-4e79-b317-9cf93626da69>"            # OS image id
}

# Create a web server
resource "openstack_compute_instance_v2" "instance_1" {
  name            = "test-server"           # Server name
  flavor_id       = "<7dfcc573-a6f8-4487-939f-25ce4b455c8f>"           # OS flavor ID
  key_pair        = "<76:a9:06:f5:5f:50:98:55:be:06:6f:4a:0a:f6:31:59>"   # SSH key provided in OS
  security_groups = ["default"]

  network {
    name = "default_network"
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v3.volume_1.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
}

resource "openstack_compute_floatingip_associate_v2" "floatip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  instance_id = "${openstack_compute_instance_v2.instance_1.id}"
}
