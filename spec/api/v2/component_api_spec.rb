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
      package_url =  "#{product_uri}/junit:junit?api_key=#{user_api.api_key}"
      get package_url
      expect( response.status ).to eql(200)
      json = JSON.parse response.body
      component = json.first
      expect( component['component_id'] ).to eq( 'junit:junit' )
    end

  end

end
