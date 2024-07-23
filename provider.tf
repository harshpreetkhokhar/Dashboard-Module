terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = ">=3.0.0"
    }
  }
}


# Configure the New Relic provider
provider "newrelic" {
  account_id = "4495087"
  api_key    =  var.apikey # Secure your API key properly in real scenarios
  region     = "US"          # Valid regions are US and EU
}
