require 'grape'

module EntitiesV2

  class ComponentEntity < Grape::Entity
    expose :ids, :as => 'id'
    expose :type
    expose :source_id
    expose :url
    expose :eventx_components, :as => 'components'
    expose :properties
    expose :created_at
    expose :updated_at
  end

end
