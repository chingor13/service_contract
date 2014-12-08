require 'test_helper'

class AssertionsTest < Minitest::Test
  include ServiceContract::Assertions

  def test_data_matching
    service = SampleService.find(1)
    assert service, "expect to find a service by version"
    assert_equal "1", service.version

    assert_equal 3, service.protocols.length
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

  def test_union_data_matching
    service = SampleService.find(2)
    assert service, "expect to find a service by version"

    protocol = service.protocol("search_param")
    endpoint = protocol.endpoint("index")

    # test can be nil
    assert_endpoint_response([{customer_id: nil}], endpoint)

    # should be able to be an integer
    assert_endpoint_response([{customer_id: 4}], endpoint)

    # should be able to be an array of ints
    assert_endpoint_response([{customer_id: [1,2,3]}], endpoint)
  end

end