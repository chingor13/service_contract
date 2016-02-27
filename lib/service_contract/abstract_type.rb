module ServiceContract
  AbstractType = Struct.new(:definition) do
    def name
      raise :not_implemented
    end

    def subtype
      nil
    end

    def fields
      []
    end

    def valid_value?(value)
      if valid_values.empty?
        true
      else
        valid_values.include?(value)
      end
    end

    def valid_values
      []
    end

    def valid_ruby_types
      [Object]
    end
  end
end
