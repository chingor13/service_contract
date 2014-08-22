module ServiceContract
  AbstractEndpoint = Struct.new(:protocol, :definition) do
    def parameters
      []
    end

    def response_type
      nil
    end
  end
end