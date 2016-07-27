require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'minitest/autorun'
require 'service_contract'

class SampleService < ServiceContract::Avro::Service
  VERSION = "0.1.2"

  def self.data_dir
    File.expand_path("../sample", __FILE__)
  end
end

class SampleDocumentation < ServiceContract::Avro::Documentation
  def service
    SampleService
  end
end
