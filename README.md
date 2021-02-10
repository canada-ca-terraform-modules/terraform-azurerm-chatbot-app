# Terraform azurerm-chatbot-app

## Introduction

This module deploys an application service plan, azure web app, azure web bot linked to a qna maker knowledgebase and application insights.

This module is compatible with azurerm v2.x

## Security Controls
* TBD

## Dependancies

Hard:

* [QNA Maker Knowledge Base](https://github.com/canada-ca-terraform-modules/terraform-azurerm-qna-knowledgebase)
* [Application registration Account](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-resources-bot-framework-faq?view=azure-bot-service-3.0#app-registration)


## Usage

```terraform
module "Chatbot-App" {
  source               = "./modules/chatbotApp"
  name                 = var.chatbotName
  location             = azurerm_resource_group.ChatbotApp-rg.location
  resourceGroupName    = azurerm_resource_group.ChatbotApp-rg.name
  prefix               = local.prefix
  QnAEndpointHostName  = module.ChatbotKBService-EN.endpoint
  QnAKnowledgebaseId   = module.ChatbotKBService-EN.KBID
  QnAAuthKey           = module.ChatbotKBService-EN.key
  bot_tier             = var.bot_tier
  bot_size             = var.bot_size
  kind                 = var.kind
  zipUrl               = var.zipUrl
  appId                = var.appId
  appPassword          = var.appPassword 
  tags                 = var.tags
}
```

## Variables Values

| Name                                    | Type   | Required | Notes                                                                                                       | 
| --------------------------------------- | ------ | -------- |------------------------------------------------------------------------------------------------------------ |
| prefix                                  | string | yes      | The prefix to add to the name for the chatbot |
| tags                                    | object | no       | Object containing a tag values - [tags pairs](#tag-object) |
| location                                | string | yes      | The location to deploy to.  canadacentral, canadaeast |
| QnAAuthKey                              | string | yes      | Your QNA knowledgebase authorization key |
| QnAEndpointHostName                     | string | yes      | Your QNA knowledgebase endpoint |
| QnAKnowledgebaseId                      | string | yes       | Your QNA knowledgebase ID |
| bot_tier                                | string | yes       | The pricing tier for your bot sdk service plan.  (ex: Free, Shared, Standard) |
| bot_size                                | string | yes       | The pricing tier size for your bot sdk service plan.  (ex: F1, D1, S1).  Note only one free one is allowed. |
| bot_sku                                 | string | yes        | The pricing sku for your bot.  (ex: F0 or S1).  Note only one free one is allowed. |
| kind                                    | string | no        | The kind of web app service to deploy.  For chatbots it defaults to sdk. |
| zipUrl                                  | string | no        | The url for your bot code.  See [Generic Example](https://bot-framework.azureedge.net/static/137365-f175dfa671/bot-packages/v1.3.27-135455/csharp-abs-webapp-v4_qnabot_precompiled.zip) |
| appId                                   | string | yes        | The appID for your app registration account. See [Application registration Account](https://docs.microsoft.com/en-us/azure/bot-service/bot-service-resources-bot-framework-faq?view=azure-bot-service-3.0#app-registration)  |
| AppPassword                             | string | yes        | The appPassword (secret) in your app registration account |
| plan_id                             | string | no        | The service plan to use.  If left out it will create one |
| plan_reserved                             | string | no        | If the service plan is reserved.  Defaults to false.  Must be true for Linux plans. |
| plan_kind                             | string | no        | The kind of the App Service Plan to create. Possible values are Windows (also available as App), Linux, elastic (for Premium Consumption) and FunctionApp (for a Consumption Plan). Defaults to Windows. Changing this forces a new resource to be created. |

### tag object

Example tag variable:

```hcl
tags = {
  "tag1name" = "somevalue"
  "tag2name" = "someothervalue"
  .
  .
  .
  "tagXname" = "some other value"
}
```


## History

| Date     | Release    | Change                                                                                                |
| -------- | ---------- | ----------------------------------------------------------------------------------------------------- |
| 20200708 | 20200708.1 | 1st commit                                                                                            |
| 20201014 | 20201014.1 | Allowing for passing in a application service plan_id 
                          Added plan_reserved.  Defaults to false.  Linux plans must be true.|
