require 'grape'

require_relative 'helpers/session_helpers'

require_relative 'entities/component_entity.rb'

module Versioneye
  class ComponentApi < Grape::API

    helpers SessionHelpers

    resource :component do

      desc "fetch component by id"
      get '/:component_id' do
        authorized?
        respond = {}


        present events, with: EntitiesV2::ComponentEntity
      end

    end
  end
end
