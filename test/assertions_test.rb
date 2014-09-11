require 'test_helper'

class AssertionsTest < Minitest::Test
  include ServiceContract::Assertions

  def test_data_matching
    service = SampleService.find(1)
    assert service, "expect to find a service by version"
    assert_equal "1", service.version

    assert_equal 2, service.protocols.length
    protocol = service.protocol("location")
    endpoint = protocol.endpoint("index")

    data = [{
      id: 1,
      type: 'state',
      county_name: nil,
      state_name: 'Washington',
      country_name: 'United States',
      city_name: nil,
      neighborhood_name: nil,
      postal_code_name: nil,
      latitude: 47.6097,
      longitude: 122.3331,
      population: 634_535,
      foo: [
        {
          timestamp: 1410278741
        }
      ],
      numbers: [
        1,
        2
      ],
      updated_at: {
        timestamp: 1410278741
      }
    }]

    assert_endpoint_response(data, endpoint)
  end

end