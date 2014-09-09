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
          value = data.fetch(field.name) do
            data.fetch(field.name.to_sym) do
              assert false, "expected #{type.name} to have attribute: #{field.name}"
            end
          end

          expected_classes = classes_for_parameter(field)
          assert (allow_nil && value.nil?) || expected_classes.any?{|klass| value.is_a?(klass)}, "expected #{type.name}.#{field.name} to be a #{expected_classes.join(", ")}"

          if field.type == "array"
            value.each do |val|
              assert_data_matches_type(val, field.subtype)
            end
          end
        end
      end
    end

    protected

    def classes_for_parameter(field)
      type = field.type
      type = type.type_sym.to_s if type.respond_to?(:type_sym)
      classes = case type
      when "array"
        Array
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