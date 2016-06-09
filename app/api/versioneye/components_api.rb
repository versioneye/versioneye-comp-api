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
        rate_limit
        authorized?
        track_apikey

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

      desc "fetch component by created time range"
      params do
        optional :api_key, type: String, desc: "API Key"
        optional :language, type: String, desc: "Programming language"
      end
      get '/created/:from_date/:to_date' do
        rate_limit
        authorized?
        track_apikey

        from_date  = params[:from_date].to_s
        to_date    = params[:to_date].to_s
        products   = Product.where( :created_at.gte => from_date, :created_at.lte => to_date )
        language = Product.decode_language( params[:language].to_s )
        if language
          products = products.where(:language => language)
        end
        components = comp_mapping( products )
        present components, with: EntitiesV2::ComponentEntity
      end

    end

  end
end
