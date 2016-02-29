require 'test_helper'

class ServiceTest < Minitest::Test

  def test_all
    assert_equal(2, SampleService.all.length)
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

  def test_union_types
    service = SampleService.find(2)
    protocol = service.protocol('search_param')

    type = protocol.type('SearchParam')
    assert(type, 'expected to find a SearchParam type')

    field = type.fields.detect{|field| field.name == 'customer_id'}
    assert(field, 'expected to find a customer_id field')

    field_type = field.type

    assert_equal('Union(null, int, Array(int))', field_type.name)
    assert_equal([NilClass, Fixnum, Array], field_type.valid_ruby_types)
  end

  def test_enum_types
    service = SampleService.find(2)
    protocol = service.protocol('social_login')
    type = protocol.type('Authorization')

    field = type.fields.detect{|field| field.name == 'provider'}
    assert(field, 'expected to find a provider field')

    field_type = field.type

    assert_equal('Enum(SocialNetwork)', field_type.name)
    assert_equal([String], field_type.valid_ruby_types)
  end

end
