module ServiceContract
  AbstractType = Struct.new(:definition) do
    def name
      raise :not_implemented
    end

    def type
      raise :not_implemented
    end

    def fields
      []
    end
  end
end