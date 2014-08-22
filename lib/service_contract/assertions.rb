module ServiceContract
  module Assertions

    def assert_endpoint_response(data, endpoint, allow_nil = true)
      assert_data_matches_type(data, endpoint.response_type, allow_nil)
    end

    def assert_data_matches_type(data, type, allow_nil = true)
      if type.is_a?(ServiceContract::Avro::ArrayType)
        assert data.is_a?(Array), "expected response to be an Array"
        data.each do |datum|
          assert_data_matches_type(datum, type.subtype)
        end
      else
        type.fields.each do |field|
          assert data.has_key?(field.name), "expected #{type.name} to have attribute: #{field.name}"
          value = data.fetch(field.name)

          expected_classes = classes_for_parameter(field)
          assert (allow_nil && value.nil?) || expected_classes.any?{|klass| value.is_a?(klass)}, "expected #{type.name}.#{field.name} to be a #{expected_classes.join(", ")}"
        end
      end
    end

    protected

    def classes_for_parameter(field)
      classes = case field.type
      when "int"
        Fixnum
      when "string"
        String
      when "float"
        Float
      when "boolean"
        [TrueClass, FalseClass]
      else # a complex type
        Hash
      end
      Array(classes)
    end

  end
end