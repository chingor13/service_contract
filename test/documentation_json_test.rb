ENV['RACK_ENV'] = 'test'

require 'test_helper'
require 'rack/test'
require 'service_contract/avro/documentation'

class DocumentationJsonTest < Minitest::Test
  include Rack::Test::Methods

  def app
    SampleDocumentation
  end

  def setup
    super
    header "Accept", "application/json"
  end

  def test_homepage_json
    get '/'
    assert_equal "application/json", last_response.headers["Content-Type"]
    assert_equal({"contract" => {
      "name" => "SampleService",
      "title" => "Avro Service",
      "description" => "",
      "versions" => [
        {"version" => "1", "link" => "/1"},
        {"version" => "2", "link" => "/2"},
      ]
    }}, JSON.parse(last_response.body))
  end

  def test_version_index_json
    get '/1'
    assert_equal "application/json", last_response.headers["Content-Type"]
    assert_equal({"version" => {
      "version" => "1",
      "protocols" => [
        {"name" => "city_state", "link" => "/1/city_state"},
        {"name" => "location", "link" => "/1/location"},
        {"name" => "sales_region", "link" => "/1/sales_region"},
      ]
    }}, JSON.parse(last_response.body))
  end
end
