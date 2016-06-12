require 'spec_helper'

describe Versioneye::ComponentsApi, :type => :request do

  let( :product_uri ) { "/api/v2/components" }
  let( :test_user   ) { UserFactory.create_new(90) }
  let( :user_api    ) { ApiFactory.create_new test_user }

  def encode_prod_key(prod_key)
    prod_key.gsub("/", ":")
  end

  describe "GET detailed info for specific component" do

    it "returns error code for not existing product" do
      product = ProductFactory.create_for_maven('junit', 'junit', '1.0.0')
      expect( product.save ).to be_truthy

      repository = Repository.new({ :src => 'https://jcenter.bintray.com', :repotype => "Maven2" })
      expect( product.repositories.push( repository ) )
      expect( product.save )

      license = License.new({
        :language => product.language,
        :prod_key => product.prod_key,
        :version => '1.0.0',
        :name => "MIT"  })
      expect( license.save ).to be_truthy

      package_url =  "#{product_uri}/junit:junit?api_key=#{user_api.api_key}"
      get package_url
      expect( response.status ).to eql(200)
      json = JSON.parse response.body
      component = json.first
      expect( component['component_id'] ).to eq( 'junit:junit' )

      expect( component['sources'].count ).to eq( 1 )
      expect( component['sources'].first['name'] ).to eq( 'Bintray JCenter' )
      expect( component['sources'].first['url'] ).to eq( 'https://jcenter.bintray.com' )
      expect( component['sources'].first['repo_type'] ).to eq( 'Maven2' )
      expect( component['sources'].first['updated'] ).to_not be_nil

      expect( component['versions'].count ).to eq( 1 )
      expect( component['versions'].count ).to eq( 1 )
      expect( component['versions'].first['version'] ).to eq( '1.0.0' )
      expect( component['versions'].first['licenses'].count ).to eq( 1 )
      expect( component['versions'].first['licenses'].first ).to eq( 'MIT' )
    end

  end

end
