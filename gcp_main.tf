provider "google" {
  project = "case-study-project-428820"
  region = "us-central1"
  zone = "us-central1-c"
  credentials = "./case-study-project-428820-320e6136b6c9.json"

}

resource "google_compute_instance" "VM_Terraform" {
  name         = "my-instance"
  machine_type  = "n1-standard-1"
  zone         = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10-buster-v20200805"
    }
  }

  network_interface {
    network = "projects/case-study-project-428820/global/networks/"
    access_config {
      
    }
  }

  metadata = {
    ssh-keys = "your-username:${file("C:/Users/Admin/my_keys.pub")}"
  }

  tags = ["http-server", "https-server"]
}

output "instance_ip" {
  value = google_compute_instance.VM_Terraform.network_interface[0].access_config[0].nat_ip
}

/* output "network_name" {
  value =data.google_compute_network.vpc-inside.name
}

output "subnetwork_name" {
  value = data.google_compute_subnetwork.subnet_inside.name
}
*/