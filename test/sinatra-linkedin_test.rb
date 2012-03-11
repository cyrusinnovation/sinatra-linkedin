require 'test_helper'
require 'rack/test'
require 'sinatra-linkedin'

module Sinatra
  class LinkedinTest < Test::Unit::TestCase
    include Rack::Test::Methods

    context 'successful authentication' do
      setup do
        request_token = mock('OAuth::RequestToken',
          :token         => 'my_token',
          :secret        => 'my_secret',
          :authorize_url => 'http://example.com/authorize_url'
        )

        client = mock('LinkedIn::Client')
        client.stubs(:request_token).returns(request_token)

        LinkedIn::Client.stubs(:new).returns(client)

        get '/auth'
      end

      test "responds with redirect" do
        assert last_response.redirect?,
          "expected redirect got #{last_response.status}"
      end

      test "redirected to authorize url" do
        assert_equal 'http://example.com/authorize_url', last_response.location
      end

      test "sets a session request token" do
        assert_equal 'my_token', last_request.env["rack.session"][:rtoken]
      end

      test "sets a session request secret" do
        assert_equal 'my_secret', last_request.env["rack.session"][:rsecret]
      end
    end

    context "authentication callback without existing access token" do
      setup do
        client = mock('LinkedIn::Client')
        client.expects(:authorize_from_request)
          .with('some rtoken', 'some rsecret', 'some pin')
          .returns(['access token', 'access secret'])

        LinkedIn::Client.stubs(:new).returns(client)

        set_session(:rtoken => 'some rtoken', :rsecret => 'some rsecret')

        get '/auth/callback', { :oauth_verifier => 'some pin' }, env
      end

      test "responds with a redirect" do
        assert last_response.redirect?,
          "expected redirect got #{last_response.status}"
      end

      test "redirects to root" do
        assert_equal 'http://example.org/', last_response.location
      end

      test "sets a session access token" do
        assert_equal 'access token', last_request.env["rack.session"][:atoken]
      end

      test "sets a session access secret" do
        assert_equal 'access secret', last_request.env["rack.session"][:asecret]
      end
    end

    context "authentication callback with existing access token" do
      setup do
        set_session :rtoken => 'some rtoken',
          :rsecret => 'some rsecret', :atoken => 'access token'

        get '/auth/callback', { :oauth_verifier => 'some pin' }, env
      end

      test "responds with a redirect" do
        assert last_response.redirect?,
          "expected redirect got #{last_response.status}"
      end

      test "redirects to root" do
        assert_equal 'http://example.org/', last_response.location
      end

      test "sets a session access token" do
        assert_equal 'access token', last_request.env["rack.session"][:atoken]
      end
    end

    context "logout" do
      setup do
        set_session(:rtoken => 'request token', :atoken => 'access token')

        get '/auth/logout', {}, env
      end

      test "responds with redirect" do
        assert last_response.redirect?,
          "expected redirect got #{last_response.status}"
      end

      test "redirects to root" do
        assert_equal 'http://example.org/', last_response.location
      end

      test "sets session request token to nil" do
        assert_nil last_request.env["rack.session"][:rtoken]
      end

      test "sets session access token to nil" do
        assert_nil last_request.env["rack.session"][:atoken]
      end
    end

    private

    def app
      Sinatra.new do
        register Sinatra::Linkedin
      end
    end

    def set_session(session_hash)
      env['rack.session'] = session_hash
    end

    def env
      @env ||= {}
    end
  end
end
