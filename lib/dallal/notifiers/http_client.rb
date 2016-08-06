require 'rest-client'

module Dallal
  module Notifiers
    class HttpClient

      [:post, :put, :get].each do |http_verb|
        define_method(http_verb) do |path, body = {}|
          request(http_verb, path, body)
        end
      end

      private
      def request(http_method, path, body = {})
        begin
          RestClient.send(http_method, path, body, content_type: :json, accept: :json)
        rescue => e
          return Dallal::Result::Error.new('Error: ', e)
        end

        return Dallal::Result::Success.new()
      end
    end
  end
end