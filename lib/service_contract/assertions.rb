module ServiceContract
  module Assertions

    def assert_endpoint_response(data, endpoint, allow_nil = true)
      assert_data_matches_type(data, endpoint.response_type, allow_nil)
    end

    def assert_data_matches_type(data, type, allow_nil = true)
      if type.array?
        assert data.is_a?(Array), "expected #{type.name} to be an Array; instead got: #{data.inspect} (#{data.class.name})"
        data.each do |datum|
          assert_data_matches_type(datum, type.subtype, allow_nil)
        end
      elsif type.complex?

        # type should have fields
        type.fields.each do |field|

          # ensure the field is present
          value = data.fetch(field.name) do
            data.fetch(field.name.to_sym) do
              assert false, "expected #{type.name} to have attribute: #{field.name}"
            end
          end

          # check the data type
          assert_data_matches_type(value, field.type, allow_nil)
        end
      else
        # type is a scalar
        assert (allow_nil && data.nil?) || type.valid_ruby_types.any?{|klass| data.is_a?(klass)}, "expected scalar type #{type.inspect} or nil; instead got: #{data.inspect} (#{data.class.name})"
      end
    end

  end
end