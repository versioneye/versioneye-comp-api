require 'grape-swagger'

module Versioneye
  class Root < Grape::API
    version 'v2', using: :path, vendor: 'versioneye'
    format :json
    prefix :api

    mount Versioneye::ComponentsApi

    add_swagger_documentation \
      info: {
        title: "VersionEye API", description: "This is the VersionEye component API. \
        Get your API key here: <a href='https://www.versioneye.com/settings/api'>https://www.versioneye.com/settings/api</a>"
      }

    before do
      header "Access-Control-Allow-Origin", "*"
      header "Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, PATCH, DELETE"
      header "Access-Control-Request-Method", "*"
      header "Access-Control-Max-Age", "1728000" # round about 20 days
      header "Access-Control-Allow-Headers", "api_key, Content-Type"
    end
  end
end
