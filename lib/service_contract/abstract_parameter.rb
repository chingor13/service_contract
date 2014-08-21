module ServiceContract
  AbstractParameter = Struct.new(:definition) do
    def name
      raise :not_implemented
    end

    def type
      raise :not_implemented
    end
  end
end