

//Does not seem to create the right oauth permisions right now.  This is a new module in June and might have a bug
//App registration account created outside for now following https://docs.microsoft.com/en-us/azure/bot-service/bot-service-resources-bot-framework-faq?view=azure-bot-service-3.0#app-registration
//Commented code left for a future date

//Requires Application Admin role for the user or SP running the code
//resource "azuread_application" "Chatbot-adapp" {
//  name                       = "${var.prefix}-wapp"
//  oauth2_permissions = []
//  oauth2_allow_implicit_flow = false
// reply_urls = null
//}

output "MicrosoftAppId" {
  //value = "${azuread_application.Chatbot-adapp.application_id}"
  value = var.appId
}

# Generate random string to be used for Service Principal password
# resource "random_string" "password" {
#   length  = 32
#   special = true
# }

# resource "azuread_application_password" "Chatbot-adapp-password" {
#   application_object_id = azuread_application.Chatbot-adapp.id
#   value          = random_string.password.result
#   end_date       = "2099-01-01T01:02:03Z"
# }

output "MicrosoftAppPassword" {
  //value = "${azuread_application_password.Chatbot-adapp-password.value}"
  value = var.appPassword
}

resource "azurerm_app_service_plan" "Chatbot-svcplan" {
  count               = var.plan_id == "" ? 1 : 0
  name                = "${var.prefix}-app-svcplan"
  location            = var.location
  resource_group_name = var.resourceGroupName
  kind                = var.plan_kind == "" ? "Windows" : var.plan_kind
  reserved            = var.plan_reserved
  sku {
    tier = var.bot_tier
    size = var.bot_size
  }
  tags = var.tags
}

resource "azurerm_application_insights" "Chatbot-app-ai" {
  name                = "${var.prefix}-app-appi"
  location            = var.location
  resource_group_name = var.resourceGroupName
  application_type    = "web"
  tags                = var.tags
}


resource "azurerm_template_deployment" "Chatbot-app-svc" {
  name                = "${var.prefix}-svc"
  resource_group_name = var.resourceGroupName
  template_body       = data.template_file.webapp_template.rendered
  # =============== ARM TEMPLATE PARAMETERS =============== #
  parameters = {
    "location"            = "${var.location}"
    "kind"                = "${var.kind}"
    "siteName"            = "${var.prefix}-svc"
    "appId"               = "${var.appId}"       //"${azuread_application.Chatbot-adapp.application_id}"
    "appSecret"           = "${var.appPassword}" //"${azuread_application_password.Chatbot-adapp-password.value}"
    "zipUrl"              = "${var.zipUrl}"
    "serverFarmId"        = "${var.plan_id == "" ? azurerm_app_service_plan.Chatbot-svcplan[0].id : var.plan_id}" //"/subscriptions/${data.azurerm_subscription.current.id}/resourceGroups/${var.resourceGroupName}/providers/Microsoft.Web/serverfarms/ScDc-CIOCPS-StudentChatbot-app-svcplan"
    "QnAKnowledgebaseId"  = "${replace(var.QnAKnowledgebaseId, "//knowledgebases//", "")}"
    "QnAAuthKey"          = "${var.QnAAuthKey}"
    "QnAEndpointHostName" = "${var.QnAEndpointHostName}"
  }
  deployment_mode = "Incremental" # Deployment => incremental (complete is too destructive in our case) 

}

//Left in for not incase at a future date they support the kind parameter
# resource "azurerm_app_service" "Chatbot-app-svc" {
#   name                = "${var.prefix}-svc"
#   location            = var.location
#   resource_group_name = var.resourceGroupName
#   app_service_plan_id = azurerm_app_service_plan.Chatbot-svcplan.id

#   site_config {
#     dotnet_framework_version = "v4.0"
#     cors {
#       allowed_origins = [ 
#         "https://portal.azure.com",
#         "https://botservice.hosting.portal.azure.net",
#         "https://botservice-ms.hosting.portal.azure.net",
#         "https://hosting.onecloud.azure-test.net/"
#       ]
#     }
#     websockets_enabled = true
#   }

#   app_settings = {
#      "WEBSITE_NODE_DEFAULT_VERSION" = "10.14.1"
#      "MicrosoftAppId": azuread_application.Chatbot-adapp.application_id
#      "MicrosoftAppPassword": azuread_application_password.Chatbot-adapp-password.value
#      "QnAKnowledgebaseId": replace(var.QnAKnowledgebaseId, "//knowledgebases//","")
#      "QnAAuthKey": var.QnAAuthKey
#      "QnAEndpointHostName": var.QnAEndpointHostName
#   }

#   depends_on = [
#       azurerm_app_service_plan.Chatbot-svcplan, azuread_application_password.Chatbot-adapp-password
#   ]
#   tags = var.tags
# }

resource "azurerm_bot_web_app" "Chatbot-app" {
  name                                  = "${var.prefix}-wapp"
  location                              = "global"
  resource_group_name                   = var.resourceGroupName
  sku                                   = var.bot_sku
  microsoft_app_id                      = var.appId //azuread_application.Chatbot-adapp.application_id
  developer_app_insights_key            = azurerm_application_insights.Chatbot-app-ai.instrumentation_key
  developer_app_insights_application_id = azurerm_application_insights.Chatbot-app-ai.app_id
  endpoint                              = "https://${var.prefix}-svc.azurewebsites.net/api/messages"
  tags                                  = var.tags
}

output "ChatbotApp" {
  value = azurerm_template_deployment.Chatbot-app-svc
}
