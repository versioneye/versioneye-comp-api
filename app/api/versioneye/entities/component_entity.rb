require 'grape'

module EntitiesV2

  class ComponentSourceEntity < Grape::Entity
    expose :name
    expose :url
    expose :repo_type
    expose :updated
  end

  class ComponentEntity < Grape::Entity
    expose :component_id
    expose :package
    expose :language
    expose :name
    expose :description
    expose :created
    expose :modified
    expose :sources, :using => ComponentSourceEntity
  end

end
