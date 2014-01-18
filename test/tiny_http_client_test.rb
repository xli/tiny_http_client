$LOAD_PATH << File.dirname(__FILE__) + '/../lib'
require 'test/unit'
require 'tiny_http_client'
require 'webrick'

class TinyHttpClientTest < Test::Unit::TestCase
  include WEBrick

  def setup
    @dir = File.join(File.dirname(__FILE__), 'data')
    @server = HTTPServer.new(Port: '1234', DocumentRoot: @dir, Logger: WEBrick::Log.new("/dev/null"), AccessLog: [])
    Thread.start do
      @server.start
    end
  end

  def teardown
    @server.shutdown
  end

  def test_get
    content = TinyHttpClient.get('http://localhost:1234/index.html')
    assert_equal "index html\n", content
  end

  def test_raise_error_when_got_response_is_not_success
    assert_raise Net::HTTPExceptions do
      TinyHttpClient.get('http://localhost:1234/error.html')
    end
  end

  def test_yield_req_obj_before_send
    request = nil
    content = TinyHttpClient.get('http://localhost:1234/index.html') do |req|
      request = req
    end

    assert_equal "index html\n", content
    assert request
    assert_equal Net::HTTP::Get, request.class
  end
end
