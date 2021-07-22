variable "account_id" {
  type = string
}

variable "azure_shared_image_gallery" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "image_description" {
  type = string
}

variable "image_name" {
  type = string
}

variable "image_version" {
  type = string
}

variable "os_disk_size" {
  type = string
}

variable "replication_region_1" {
  type = string
  default = ""
}

variable "replication_region_2" {
  type = string
  default = ""
}

variable "replication_region_3" {
  type = string
  default = ""
}

variable "resource_group_location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "service_principal_app_id_uri" {
  type = string
}

variable "service_principal_client_id" {
  type = string
}

variable "service_principal_client_secret" {
  type = string
}

variable "service_principal_tenant_id" {
  type = string
}

variable "this_offer" {
  type = string
}

variable "this_publisher" {
  type = string
}

variable "this_sku" {
  type = string
}

variable "vm_offer" {
  type = string
}

variable "vm_plan" {
  type = string
}

variable "vm_publisher" {
  type = string
}

source "azure-arm" "windows" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  build_resource_group_name         = "${var.resource_group_name}"
  client_id                         = "${var.service_principal_client_id}"
  client_secret                     = "${var.service_principal_client_secret}"
  cloud_environment_name            = "Public"
  communicator                      = "winrm"
  image_offer                       = "${var.vm_offer}"
  image_publisher                   = "${var.vm_publisher}"
  image_sku                         = "${var.vm_plan}"
  managed_image_name                = "${var.image_name}"
  managed_image_resource_group_name = "${var.resource_group_name}"
  os_disk_size_gb                   = "${var.os_disk_size}"
  os_type                           = "Windows"
  shared_image_gallery_destination {
    gallery_name        = "${var.azure_shared_image_gallery}"
    image_name          = "${var.image_name}"
    image_version       = "${var.image_version}"
    replication_regions = ["${var.replication_region_1}", "${var.replication_region_2}", "${var.replication_region_3}"]
    resource_group      = "${var.resource_group_name}"
    subscription        = "${var.azure_subscription_id}"
  }
  subscription_id = "${var.azure_subscription_id}"
  vm_size         = "Standard_DS2_v2"
  winrm_insecure  = true
  winrm_timeout   = "20m"
  winrm_use_ssl   = true
}

build {
  sources = ["source.azure-arm.windows"]

  provisioner "powershell" {
    inline = ["mkdir c:\\scripts"]
  }

  provisioner "file" {
    destination = "c:\\scripts\\sql-express-install-config.ini"
    source      = "./scripts/sql-express-install-config.ini"
  }

  provisioner "powershell" {
    scripts = ["./scripts/install-iis.ps1", "./scripts/install-sqlexpress.ps1", "./scripts/install-ca.ps1"]
  }

  provisioner "powershell" {
    inline = ["mkdir \"$env:systemdrive\\inetpub\\demoSite\""]
  }

  provisioner "powershell" {
    script = "./scripts/sysprep-image.ps1"
  }

}
