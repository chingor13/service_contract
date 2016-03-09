module ServiceContract
  module Assertions

    def assert_endpoint_response(data, endpoint, allow_nil = true)
      assert_data_matches_type(data, endpoint.response_type, allow_nil)
    end

    def assert_data_matches_type(data, type, allow_nil = true)
      # Skip out if object is nil and allowed to be nil
      return true if data.nil? && allow_nil

      # basic type checking
      assert type.valid_type?(data), "expected `#{data}` (#{type.name}) to be one of #{type.valid_ruby_types}"
      assert type.valid_value?(data), "#{data} is not an allowed value of type: #{type.name}"

      # check subtype
      if type.subtype
        data.each do |datum|
          assert_data_matches_type(datum, type.subtype, allow_nil)
        end
      end

      # check subfields
      type.fields.each do |field|
        #Does data contain attributes that the contract doesn't specify?
        data_extra_attrs = (data.keys.map(&:to_sym) - type.fields.map{|n| n.name.to_sym})
        assert_equal 0, data_extra_attrs.size, "#{type.name} contains attributes not described in contract: #{data_extra_attrs.join(',')}"

        # ensure the field is present
        value = data.fetch(field.name) do
          data.fetch(field.name.to_sym) do
            assert false, "expected #{type.name} to have attribute: #{field.name}"
          end
        end

        # check the data type
        assert_data_matches_type(value, field.type, allow_nil)
      end
    end

  end
end
