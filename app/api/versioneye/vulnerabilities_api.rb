require 'grape'

require_relative 'helpers/session_helpers'
require_relative 'helpers/vulnerability_helpers'

require_relative 'entities/vulnerability_entity.rb'

module Versioneye
  class VulnerabilitiesApi < Grape::API

    helpers SessionHelpers
    helpers VulnerabilityHelpers

    resource :vulnerabilities do


      desc "fetch vulnerability by id"
      params do
        optional :api_key, type: String, desc: "API Key"
      end
      get '/:vulnerability_id' do
        rate_limit
        authorized?
        track_apikey

        sv_id         = params[:vulnerability_id].to_s
        vulnerability = SecurityVulnerability.find sv_id

        vuln = vuln_mapping( vulnerability )
        present vuln, with: EntitiesV2::VulnerabilityEntity
      end

    end

  end
end
