require 'grape'

require_relative 'helpers/session_helpers'

require_relative 'entities/component_entity.rb'

module Versioneye
  class ComponentsApi < Grape::API

    helpers SessionHelpers

    resource :components do

      desc "fetch component by id"
      params do
        optional :api_key, type: String, desc: "API Key"
      end
      get '/:component_id' do
        authorized?

        comp_id = params[:component_id].to_s
        comp_id = comp_id.gsub(":", "/")
        products = Product.where(:prod_key => comp_id)

        components = []
        products.each do |product|

          sources = []
          product.repositories.each do |repo|
            repo_type = repo.repotype
            repo_type = product.prod_type if repo_type.to_s.empty?
            sources << {
              :name => Repository.name_for(repo.src),
              :url => repo.src,
              :repo_type => repo_type,
              :updated => product.updated_at
            }
          end

          components << {
            :component_id => product.to_param.to_s,
            :package => product.prod_type,
            :name => product.name,
            :description => product.description,
            :created => product.created_at,
            :modified => product.updated_at,
            :sources => sources
          }
        end

        present components, with: EntitiesV2::ComponentEntity
      end

    end
  end
end
