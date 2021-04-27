# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-install-rdp.sh")
}

data "template_file" "guac-init" {
  template = file("guac-install.sh")
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "Packet-Analysis-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.packet-instance.id]
  vm_size               = "Standard_A1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "packet-analysis-instance"
    admin_username = "arsiem"
    admin_password = "Arsiem2020!!"
    custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      # Note: If you did ssh-keygen and used a different name, replace mykey.pub with the new public key name
      key_data = file("mykey.pub")
      path     = "/home/arsiem/.ssh/authorized_keys"
    }
  }
  tags = {
    environment = "Packet Analysis Lab"
  }
}

resource "azurerm_virtual_machine" "guac-vm" {
  name                  = "guac-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.guac-instance.id]
  vm_size               = "Standard_A1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "packet-analysis-guac-instance"
    admin_username = "arsiem"
    admin_password = "Arsiem2020!!"
    custom_data = base64encode(data.template_file.guac-init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      # Note: If you did ssh-keygen and used a different name, replace mykey.pub with the new public key name
      key_data = file("mykey.pub")
      path     = "/home/arsiem/.ssh/authorized_keys"
    }
  }
  tags = {
    environment = "Packet Analysis Lab"
  }
}


resource "azurerm_managed_disk" "guac-disk" {
  name                 = "Packet-Analysis-Guac-Disk"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb         = "1"
  tags = {
    environment = "Packet Analysis Lab"
  }
}

resource "azurerm_managed_disk" "disk" {
  name                 = "Packet-Analysis-Disk"
  location             = var.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb         = "1"
  tags = {
    environment = "Packet Analysis Lab"
  }
}

resource "azurerm_public_ip" "packet-instance" {
    name                         = "instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}

resource "azurerm_public_ip" "guac-instance" {
    name                         = "guac-instance1-public-ip"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Static"
}