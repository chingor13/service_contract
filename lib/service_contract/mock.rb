require 'faker'

module ServiceContract
  class Mock
    class << self
      # generates fake data that adheres to the types defined in the service contract
      def generate!(version)
        mock_fields(type(version))
      end

      private

      def type(version)
        raise "not_implemented"
      end

      # can set up custom generators by field name
      #   should be a hash of <field_name> => <lambda>
      def customizations
        {}
      end

      def mock_fields(type)
        {}.tap do |res|
          type.fields.each do |parameter|
            if customizations.key?(parameter.name)
              res[parameter.name] = customizations[parameter.name].call
            else
              res[parameter.name] = mock_value(parameter.type)
            end
          end
        end
      end

      def mock_value(field)
        if field.array?
          Array.new(3) do
            mock_value(field.subtype)
          end
        elsif field.complex?
          # recursively mock values
          mock_fields(field)
        else
          case field.name
          when "int", :int
            Random.new.rand(10000000)
          when "string", :string
            Faker::Hacker.noun
          when "float", :float
            Random.new.rand(10000.0)
          when "boolean", :boolean
            [true, false].sample
          end
        end        
      end
    end
  end
end