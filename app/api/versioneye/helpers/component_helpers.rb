require 'htmlentities'

module ComponentHelpers


  def comp_mapping products
    i = 0
    components = []
    products.each do |product|
      i += 1
      p i
      # break if i > 9

      sources = []
      product.repositories.each do |repo|
        repo_type = repo.repotype
        repo_type = product.prod_type if repo_type.to_s.empty?
        sources << {
          :name => Repository.name_for(repo.src),
          :url => repo.src,
          :repo_type => repo_type,
          :updated => repo.updated_at
        }
      end

      versions = []
      product.versions.each do |version|
        license_a = []
        licenses = License.where( :language => product.language, :prod_key => product.prod_key, :version => version.to_s )
        licenses.each do |license|
          next if license_a.include?(license.name)
          license_a << license.name
        end

        files = {}
        archives = Versionarchive.where( :language => product.language, :prod_key => product.prod_key, :version_id => version.to_s )
        archives.each do |archive|
          next if files.keys.include?(archive.name)
          next if archive.language.eql?("Java") && !archive.name.match(/javadoc\.jar\z/i).nil?
          next if archive.language.eql?("Java") && !archive.name.match(/sources\.jar\z/i).nil?
          files[archive.name] = {:name => archive.name, :url => archive.link}
        end

        versions << {
          :version => version.to_s,
          :released => version.released_at,
          :vulnerabilities => version.sv_ids,
          :licenses => license_a,
          :files => files.values
        }
      end

      components << {
        :component_id => product.to_param.to_s,
        :package => product.prod_type,
        :language => product.language,
        :name => product.name,
        :description => product.description,
        :created => product.created_at,
        :modified => product.updated_at,
        :sources => sources,
        :versions => versions
      }

    end

    components
  end


end
