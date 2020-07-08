data "azurerm_client_config" "current" {
}

# =============== TEMPLATES =============== #
data "template_file" "webapp_template" {
  template = file("${path.module}/arm_templates/web_app.json")
}