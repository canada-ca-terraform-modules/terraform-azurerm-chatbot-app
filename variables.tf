


variable "tags" {}
variable "prefix" {}

variable "resourceGroupName" {}

variable "location" {}

variable "QnAAuthKey" {}

variable "QnAEndpointHostName" {}

variable "QnAKnowledgebaseId" {
  
}

variable "bot_tier" {
  default = "Free"
  description = "The tier for the chatbot application service plan.  Free, Shared, Standard"
}

variable "bot_size" {
  default = "F1"
  description = "The size for the chatbot application.  F1, D1, S1.  Only get one free one"
}

variable "bot_sku" {
  default = "S1"
  description = "The size for the chatbot application.  F0 or S1.  Only get one free one"
}

variable "kind" {
  default = "sdk"
  description = "The kind of web app to deploy"
}

variable "zipUrl" {
  default = ""
}

variable "appId" {}
variable "appPassword" {}