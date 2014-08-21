require 'avro'

module ServiceContract
  module Avro
    autoload :Documentation, 'service_contract/avro/documentation'
    autoload :Endpoint, 'service_contract/avro/endpoint'
    autoload :Errors, 'service_contract/avro/errors'
    autoload :Parameter, 'service_contract/avro/parameter'
    autoload :Protocol, 'service_contract/avro/protocol'
    autoload :Service, 'service_contract/avro/service'
    autoload :Type, 'service_contract/avro/type'
  end
end