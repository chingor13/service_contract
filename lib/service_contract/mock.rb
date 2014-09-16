require 'random-word'

module ServiceContract
  class Mock
    class << self
      # generates fake data that adheres to the types defined in the service contract
      def generate!(version)
        {}.tap do |res|
          type(version).fields.each do |parameter|
            res[parameter.name] = mock_value(parameter.type)
          end
        end
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

      def mock_value(field)
        return customizations[field.name].call if customizations.key?(field.name)

        if field.array?
          Array.new(3) do
            mock_value(field.subtype)
          end
        elsif field.complex?
          # recursively mock values
          {}.tap do |res|
            field.fields.each do |parameter|
              res[parameter.name] = mock_value(parameter.type)
            end
          end
        else
          case field.name
          when "int", :int
            Random.new.rand(10000000)
          when "string", :string
            RandomWord.nouns.next
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