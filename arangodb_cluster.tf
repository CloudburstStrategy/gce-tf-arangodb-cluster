variable "gce_project" {}
variable "gce_region" {}
variable "gce_machine_type" {}
variable "cluster_name" {}
variable "arangodb_password" {}

# Configure the provider
provider "google" {
  project     = "${var.gce_project}"
  region      = "${var.gce_region}"
}

# Allow access from internet to ArangoDB web admin console
resource "google_compute_firewall" "default" {
  name    = "arangodb-graph-rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8529"]
  }

  target_tags = ["arangodb"]
}

# Create 3 static IP addresses
resource "google_compute_address" "ipa" {
  name = "arangodb-${var.cluster_name}-ipa"
}
resource "google_compute_address" "ipb" {
  name = "arangodb-${var.cluster_name}-ipb"
}
resource "google_compute_address" "ipc" {
  name = "arangodb-${var.cluster_name}-ipc"
}

# Create 3 persistent disks
resource "google_compute_disk" "diska" {
  name = "arangodb-${var.cluster_name}-diska"
  zone = "${var.gce_region}-a"
}
resource "google_compute_disk" "diskb" {
  name = "arangodb-${var.cluster_name}-diskb"
  zone = "${var.gce_region}-b"
}
resource "google_compute_disk" "diskc" {
  name = "arangodb-${var.cluster_name}-diskc"
  zone = "${var.gce_region}-c"
}

# Create 3 hosts - one in each zone a,b & c
resource "google_compute_instance" "hosta" {
  name         = "arangodb-${var.cluster_name}-hosta"
  machine_type = "${var.gce_machine_type}"
  zone         = "${var.gce_region}-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size = 10
    }
  }

  attached_disk {
    source = "${google_compute_disk.diska.self_link}"
    device_name = "db"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.ipa.address}"
    }
  }

  tags = ["arangodb"]

  provisioner "file" {
    source      = "scripts/setupdisk.sh"
    destination = "/tmp/setupdisk.sh"
  }

  provisioner "file" {
    source      = "scripts/start.sh"
    destination = "/tmp/start.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setupdisk.sh",
      "/tmp/setupdisk.sh",
      "chmod +x /tmp/start.sh",
      "/tmp/start.sh ${google_compute_address.ipa.address} ${google_compute_address.ipb.address} ${google_compute_address.ipc.address}",
    ]

    connection {
      type     = "ssh"
      timeout  = "10m"
    }
  }
}

resource "google_compute_instance" "hostb" {
  name         = "arangodb-${var.cluster_name}-hostb"
  machine_type = "${var.gce_machine_type}"
  zone         = "${var.gce_region}-b"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size = 10
    }
  }

  attached_disk {
    source = "${google_compute_disk.diskb.self_link}"
    device_name = "db"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.ipb.address}"
    }
  }

  tags = ["arangodb"]

  provisioner "file" {
    source      = "scripts/setupdisk.sh"
    destination = "/tmp/setupdisk.sh"
  }

  provisioner "file" {
    source      = "scripts/start.sh"
    destination = "/tmp/start.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setupdisk.sh",
      "/tmp/setupdisk.sh",
      "chmod +x /tmp/start.sh",
      "/tmp/start.sh ${google_compute_address.ipa.address} ${google_compute_address.ipb.address} ${google_compute_address.ipc.address}",
    ]

    connection {
      type     = "ssh"
      timeout  = "10m"
    }
  }
}

resource "google_compute_instance" "hostc" {
  name         = "arangodb-${var.cluster_name}-hostc"
  machine_type = "${var.gce_machine_type}"
  zone         = "${var.gce_region}-c"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size = 10
    }
  }

  attached_disk {
    source = "${google_compute_disk.diskc.self_link}"
    device_name = "db"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.ipc.address}"
    }
  }

  tags = ["arangodb"]

  provisioner "file" {
    source      = "scripts/setupdisk.sh"
    destination = "/tmp/setupdisk.sh"
  }

  provisioner "file" {
    source      = "scripts/start.sh"
    destination = "/tmp/start.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setupdisk.sh",
      "/tmp/setupdisk.sh",
      "chmod +x /tmp/start.sh",
      "/tmp/start.sh ${google_compute_address.ipa.address} ${google_compute_address.ipb.address} ${google_compute_address.ipc.address}",
    ]

    connection {
      type     = "ssh"
      timeout  = "10m"
    }
  }
}
