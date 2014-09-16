require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'minitest/autorun'
require 'service_contract'

class SampleService < ServiceContract::Avro::Service
  def self.data_dir
    File.expand_path("../sample", __FILE__)
  end
end