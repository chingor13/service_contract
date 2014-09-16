require 'test_helper'

class LocationMock < ServiceContract::Mock
  VALID_TYPES = %w(country state city county neighborhood postal_code)

  def self.type(version)
    SampleService.find(version).protocol("location").type("Location")
  end

  def self.customizations
    {
      "type" => -> { VALID_TYPES.sample }
    }
  end
end

class MockTest < Minitest::Test
  include ServiceContract::Assertions

  def test_mocking
    data = Array.new(2) { LocationMock.generate!(1) }

    service = SampleService.find(1)
    protocol = service.protocol("location")
    endpoint = protocol.endpoint("index")

    assert_endpoint_response(data, endpoint)

    # test customizations
    data.each do |datum|
      assert LocationMock::VALID_TYPES.include?(datum["type"]), "should be able to override a type generator with class level customizations"
    end
  end

end