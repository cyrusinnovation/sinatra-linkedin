require "linkedin"

module Sinatra
  module Linkedin
    ##
    # Helper methods that will be available in your Sinatra application.
    module Helpers
      ##
      # Indicates whether or not the authorization token is present in the
      # session.
      def authorized?
        session[:atoken].nil? ? false : true
      end

      ##
      # Redirects the user to the authentication page unless an authorization
      # token is already present. If the token is present, do nothing.
      def authorize!
        redirect '/auth' unless authorized?
      end

      ##
      # Provides a hook for the +LinkedIn::Client+ object. You can call any
      # available LinkedIn::Client method. Refer to the
      # LinkedIn[https://github.com/pengwynn/linkedin] gem for a list of methods.
      def client
        @client ||= LinkedIn::Client.new(settings.linkedin_api_key, settings.linkedin_api_secret)
      end
    end
  end
end
