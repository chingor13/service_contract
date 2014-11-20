require 'test_helper'

class ServiceTest < Minitest::Test

  def test_all
    assert_equal(1, SampleService.all.length)
  end

  def test_find
    service = SampleService.find(1)
    assert service, "expect to find a service by version"
    assert_equal "1", service.version

    assert_equal 3, service.protocols.length
    protocol = service.protocol("location")

    assert_equal "location", protocol.name
    assert_equal 3, protocol.endpoints.length
  end

  def test_null_params
    # the member? method would error if the endpoint method had no parameters.  This test verifies the fix.
    service = SampleService.find(1)
    protocol = service.protocol("city_state")

    # find the endpoint with no parameters.
    empty_param_endpoints = protocol.endpoints.select{|e| e.parameters.empty?}
    assert !empty_param_endpoints.empty?

    empty_param_endpoints.each do |endpoint|
      assert_equal(false, endpoint.send("member?"))
    end
  end

  # The member? method determines if an endpoint is a "member" by looking at its first parameter.  If that parameter
  # is equal to the 'main_type' then it is a member, otherwise it is not a member.  Main_type is nothing more than the
  # classname of the protocol.
  def test_member_endpoint
    service = SampleService.find(1)
    protocol = service.protocol("city_state")

    # only one endpoint is a member method, "member_method"
    member_names = protocol.endpoints.select{|e| e.send("member?")}.map(&:name)
    assert_equal(1, member_names.length)
    assert_equal('member_method', member_names.first)
  end

  def test_non_member_endpoint
    service = SampleService.find(1)
    protocol = service.protocol("city_state")

    # two endpoints are non member method, "bogus" and "non_member_method"
    non_member_names = protocol.endpoints.select{|e| !e.send("member?")}.map(&:name)
    assert_equal(2, non_member_names.length)
    assert non_member_names.include?('non_member_method')
    assert non_member_names.include?('bogus')
  end

end