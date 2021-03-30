
variable "azure_subscription_id" {
    type    = string
    default = ""
}

variable "location" {
    type    = string
    default = "centralus"
}

variable "base_name" {
    type    = string
    default = "dummybase"
}

variable "image_uri" {
    type    = string
    default = ""
}

variable "os_type" {
    type    = string
    default = "Linux"
}

variable "hostname" {
    type    = string
    default = "demo"
}

variable "admin_username" {
    type    = string
    default = "demo"
}

variable "admin_password" {
    type    = string
    default = "demo"
}

variable "vm_sku" {
    type    = string
    default = "demo"
}