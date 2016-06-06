require 'vcr'
require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes/'
  c.ignore_localhost = true
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
