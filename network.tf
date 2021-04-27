resource "azurerm_network_security_group" "packet-instance" {
  name                = "Packet-Analysis-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name


  security_rule {
    name                       = "Allow-SSH"
    description                = "Allow SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "Allow-RDP"
    description                = "Allow RDP"
    priority                   = 299
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-Guac"
    description                = "Allow Guac"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "Allow-4822"
    description                = "Allow 4822"
    priority                   = 298
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "4822"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-Packet-Analysis-eastus-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.20.0/24"]

}


resource "azurerm_network_interface" "guac-instance" {
  name                      = "packet-analysis-guac-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "instance1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.guac-instance.id
    subnet_id                     = azurerm_subnet.packet-instance.id
  }
}

resource "azurerm_network_interface" "packet-instance" {
  name                      = "packet-analysis-instance1"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "instance1"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.packet-instance.id
    subnet_id                     = azurerm_subnet.packet-instance.id
  }
}

resource "azurerm_subnet" "packet-instance" {
  name                 = "packet-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.20.0/24"]
}

resource "azurerm_storage_account" "storageacc" {
  name                     = "storageacc1254346"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_interface_security_group_association" "guac-instance" {
  network_interface_id      = azurerm_network_interface.guac-instance.id
  network_security_group_id = azurerm_network_security_group.packet-instance.id
}

resource "azurerm_network_interface_security_group_association" "packet-instance" {
  network_interface_id      = azurerm_network_interface.packet-instance.id
  network_security_group_id = azurerm_network_security_group.packet-instance.id
}