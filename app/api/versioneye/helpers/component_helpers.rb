require 'htmlentities'

module ComponentHelpers


  def comp_mapping products
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

    components
  end


end
