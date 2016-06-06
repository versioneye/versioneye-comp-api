require 'grape'

module EntitiesV2

  class ComponentEntity < Grape::Entity
    expose :component_id
    expose :package
    expose :name
    expose :description
    expose :created
    expose :modified
  end

end
