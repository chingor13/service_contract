ENV['RACK_ENV'] = 'test'

require 'test_helper'
require 'rack/test'
require 'capybara'
require 'capybara/dsl'
require 'service_contract/avro/documentation'

class DocumentationTest < Minitest::Test
  include Capybara::DSL

  class SampleDocumentation < ServiceContract::Avro::Documentation
    def service
      SampleService
    end
  end

  def setup
    super
    Capybara.app = SampleDocumentation
  end

  def test_homepage_html
    visit '/'
    assert page.find("a[href='http://www.example.com/1']", text: "Version 1")
    assert page.find("a[href='http://www.example.com/2']", text: "Version 2")
  end

  def test_version_index_html
    visit '/1'
    assert page.find("a[href='http://www.example.com/1/city_state']", text: "city_state")
    assert page.find("a[href='http://www.example.com/1/location']", text: "location")
    assert page.find("a[href='http://www.example.com/1/sales_region']", text: "sales_region")
  end

  def test_version_protocol_html
    visit '/1/city_state'
    assert page.has_content?("CityState params")
  end
end
