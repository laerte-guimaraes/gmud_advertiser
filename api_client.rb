require 'net/http'
require 'json'

module ApiClient
  def post_notification(url, endpoint, body=nil)
    uri = URI(url + endpoint)

    Net::HTTP.post(uri, body)
  end
end
