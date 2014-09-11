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

    def array?
      false
    end

    def complex?
      false
    end

    def valid_ruby_types
      [Object]
    end
  end
end