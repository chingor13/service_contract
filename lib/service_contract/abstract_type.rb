module ServiceContract
  AbstractType = Struct.new(:definition) do
    def name
      raise NotImplementedError, "need to implement `name`"
    end

    def subtype
      nil
    end

    def fields
      []
    end

    def valid_type?(value)
      valid_ruby_types.any?{|type| value.is_a?(type) }
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
