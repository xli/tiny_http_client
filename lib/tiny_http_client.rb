require 'net/http'
require 'net/https'

module TinyHttpClient
  module_function

  def get(url, &block)
    uri = URI(url)
    http_opts = { use_ssl: uri.scheme == 'https' }
    Net::HTTP.start uri.host, uri.port, http_opts do |https|
      req = Net::HTTP::Get.new(uri.path)
      yield(req) if block_given?
      case res = https.request(req)
      when Net::HTTPSuccess
        res.body
      else
        res.error!
      end
    end
  end
end
