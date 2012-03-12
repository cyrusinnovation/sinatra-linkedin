require "sinatra-linkedin/helpers"
require "sinatra-linkedin/version"
require "sinatra/base"

module Sinatra
  ##
  # Provides helpers for accessing the LinkedIn API in Sinatra applications.
  # Relies on the {LinkedIn gem}[https://github.com/pengwynn/linkedin] to do
  # the heavy lifting.
  module Linkedin
    ##
    # Registers 3 routes that will be available in your app:
    #
    # /auth::
    #     authorizes the user by setting up a request token and redirecting to
    #     the LinkedIn authorization page. Once the user has granted access (or
    #     denied it) they will be redirected to /auth/callback (see below).
    #
    # /auth/callback::
    #     stores the token and secret in the session, then redirects to the root
    #     URL.
    #
    # /auth/logout::
    #     deletes the token and secret from the session and redirects the user
    #     to the root URL.
    def self.registered(app)
      app.helpers Helpers

      app.set :linkedin_api_key, "change me"
      app.set :linkedin_api_secret, "change me"

      app.get '/auth' do
        request_token = client.request_token(:oauth_callback =>
          "http://#{request.host}:#{request.port}/auth/callback")

        session[:rtoken]  = request_token.token
        session[:rsecret] = request_token.secret

        redirect client.request_token.authorize_url
      end

      app.get '/auth/callback' do
        if session[:atoken].nil?
          pin = params[:oauth_verifier]
          session[:atoken], session[:asecret] =
            client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
        end

        redirect '/'
      end

      app.get '/auth/logout' do
        session[:rtoken] = nil
        session[:atoken] = nil
        redirect '/'
      end

    end
  end

  register Linkedin
end
