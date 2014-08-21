require 'test_helper'

class ServiceTest < Minitest::Test

  def test_all
    assert_equal(1, SampleService.all.length)
  end

  def test_find
    service = SampleService.find(1)
    assert service, "expect to find a service by version"
    assert_equal "1", service.version

    assert_equal 2, service.protocols.length
    protocol = service.protocol("location")

    assert_equal "location", protocol.name
    assert_equal 3, protocol.endpoints.length
  end

end