require 'avro'

module ServiceContract
  module Avro
    autoload :Endpoint, 'service_contract/avro/endpoint'
    autoload :Errors, 'service_contract/avro/errors'
    autoload :Parameter, 'service_contract/avro/parameter'
    autoload :Protocol, 'service_contract/avro/protocol'
    autoload :Service, 'service_contract/avro/service'
  end
end