terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.43.0"
    }
  }
}


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource-group" {
  name     = "rg-webapp-php"
  location = "East US"

}

resource "azurerm_service_plan" "myapp_plan" {
  name                = "myappservice-plan01"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  os_type = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "myweb_app453624" {
  name                = "mywebapp-453624"
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
  service_plan_id = azurerm_service_plan.myapp_plan.id

  site_config {

    application_stack {
      php_version = "7.4"
    }

  }
}

resource "azurerm_app_service_source_control" "source_control" {
  app_id   = azurerm_linux_web_app.myweb_app453624.id
  repo_url = "https://github.com/gvndverma787/simple-php-website.git"
  branch   = "master"
  use_manual_integration = false
  use_mercurial = false
}

output "webapp_url" {
  description = "show webapp url"
  value = azurerm_linux_web_app.myweb_app453624.default_hostname
  
}
