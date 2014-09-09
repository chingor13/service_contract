module ServiceContract
  AbstractParameter = Struct.new(:definition) do
    def name
      raise :not_implemented
    end

    def type
      raise :not_implemented
    end

    def subtype
      nil
    end

    def default
      nil
    end

    def doc
      nil
    end
  end
end