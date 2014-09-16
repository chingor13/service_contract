require 'test_helper'

class LocationMock < ServiceContract::Mock
  def self.type(version)
    SampleService.find(version).protocol("location").type("Location")
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
  end

end