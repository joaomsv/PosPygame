provider "azurerm" {
  subscription_id = local.tags["sub_id"]
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.tags["resourcegroup"]
  location = local.tags["azureregion"]
}

# 2. Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = local.tags["vnet"]
  address_space       = ["10.0.0.0/16"]
  location            = local.tags["azureregion"]
  resource_group_name = local.tags["resourcegroup"]
  depends_on          = [azurerm_resource_group.rg]
}

# 3. Subnet Pública
resource "azurerm_subnet" "subnet" {
  name                 = local.tags["subnet"]
  resource_group_name  = local.tags["resourcegroup"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  depends_on = [azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
}

# 4. Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "public-ip"
  location            = local.tags["azureregion"]
  resource_group_name = local.tags["resourcegroup"]
  allocation_method   = local.tags["vm_ip_allocated"]
  # sku                 = "Standard"

  depends_on = [azurerm_resource_group.rg,
    azurerm_virtual_network.vnet,
    azurerm_subnet.subnet
  ]
}

# 5. Network Security Group (Security Group)
resource "azurerm_network_security_group" "nsg" {
  name                = local.tags["securitygroup"]
  location            = local.tags["azureregion"]
  resource_group_name = local.tags["resourcegroup"]

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.rg,
    azurerm_virtual_network.vnet
  ]
}

# 6. Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-vm"
  location            = local.tags["azureregion"]
  resource_group_name = local.tags["resourcegroup"]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  depends_on = [azurerm_resource_group.rg,
    azurerm_subnet.subnet,
    azurerm_public_ip.public_ip
  ]
}

resource "azurerm_network_interface_security_group_association" "nicsga" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [azurerm_resource_group.rg,
    azurerm_network_interface.nic
  ]
}

# 7. Máquina Virtual (VM)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.tags["Matrícula"]}"
  resource_group_name = local.tags["resourcegroup"]
  location            = local.tags["azureregion"]
  size                = local.tags["instancetype"]
  admin_username      = local.tags["nomeusuariovm"]

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = local.tags["nomeusuariovm"]
    public_key = local.tags["ssh_key"]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "vm-osdisk"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# 8. Storage Account (equiv. Bucket S3)
resource "azurerm_storage_account" "storage" {
  name                     = local.tags["storageaccount"]
  resource_group_name      = local.tags["resourcegroup"]
  location                 = local.tags["azureregion"]
  account_tier             = "Standard"
  account_replication_type = "GRS"

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_storage_container" "container" {
  name                  = local.tags["datalake"]
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "blob"
  depends_on            = [azurerm_storage_account.storage]
}
