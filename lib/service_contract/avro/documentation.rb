require 'sinatra/base'
require 'sinatra/json'
require 'slim'

module ServiceContract
  module Avro
    class Documentation < Sinatra::Base
      get '/:version/:protocol' do
        version = service.find(params[:version])
        protocol = version.protocol(params[:protocol])
        if request_json?
          content_type "application/json"
          send_file File.join(service.data_dir, version.version, "compiled", "#{protocol.name}.avpr")
        else
          slim :protocol, locals: { version: version, protocol: protocol }
        end
      end

      get '/:version' do
        version = service.find(params[:version])

        if version
          if request_json?
            json version: {
              version: version.version,
              protocols: version.protocols.map { |protocol|
                {
                  name: protocol.name,
                  link: "/#{version.version}/#{protocol.name}"
                }
              }
            }
          else
            slim :version, locals: { version: version }
          end
        else
          status 404
        end
      end

      get '/' do
        if request_json?
          json contract: {
            name: service.name,
            title: service.title,
            description: service.description,
            release_version: release_version,
            versions: service.all.map { |version|
              {
                version: version.version,
                link: "/#{version.version}"
              }
            }
          }
        else
          slim :homepage
        end
      end

      helpers do
        def service
          raise :not_implemented
        end

        def request_json?
          request.accept.map(&:entry).include?("application/json")
        end

        def release_version
          service.const_defined?("VERSION") ? service.const_get("VERSION") : ""
        end
      end
    end
  end
end
