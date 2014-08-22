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
  end
end