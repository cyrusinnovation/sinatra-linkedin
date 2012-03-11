require 'test_helper'
require 'sinatra-linkedin/helpers'

module Sinatra
  module Linkedin
    class HelpersTest < Test::Unit::TestCase
      include Sinatra::Linkedin::Helpers

      test "authorized? returns true if access token is present" do
        session_set(:atoken, 'authorized token')
        assert_equal true, authorized?
      end

      test "authorized? returns false if access token is not present" do
        assert_equal false, authorized?
      end

      test "authorize! redirects to /auth if session is not authorized" do
        self.expects(:redirect).with('/auth')
        authorize!
      end

      test "authorize! does nothing if session is authorized" do
        session_set(:atoken, 'authorized token')
        authorize!
      end

      private

      def session
        @session ||= {}
      end

      def session_set(key, value)
        session[key] = value
      end
    end
  end
end
