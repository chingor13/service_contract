ENV['RACK_ENV'] = 'test'

require 'test_helper'
require 'rack/test'
require 'service_contract/avro/documentation'

class DocumentationJsonTest < Minitest::Test
  include Rack::Test::Methods

  def app
    SampleDocumentation
  end

  def test_homepage_json
    header "Accept", "application/json"
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
end
