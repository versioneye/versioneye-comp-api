require 'grape'

require_relative 'helpers/session_helpers'
require_relative 'helpers/component_helpers'

require_relative 'entities/component_entity.rb'

module Versioneye
  class ComponentsApi < Grape::API

    helpers SessionHelpers
    helpers ComponentHelpers

    resource :components do

      desc "fetch component by id"
      params do
        optional :api_key, type: String, desc: "API Key"
        optional :language, type: String, desc: "Programming language"
        optional :package_type, type: String, desc: "Package Manager"
      end
      get '/:component_id' do
        authorized?

        comp_id  = params[:component_id].to_s
        comp_id  = comp_id.gsub(":", "/")
        products = Product.where(:prod_key => comp_id)
        language = Product.decode_language( params[:language].to_s )
        if language
          products = products.where(:language => language)
        end
        if !params[:package_type].to_s.empty?
          products = products.where(:prod_type => params[:package_type].to_s )
        end

        components = comp_mapping( products )
        present components, with: EntitiesV2::ComponentEntity
      end

    end

  end
end
