require 'rest-client'
require 'json'

module ApiClient
  def request(verb, url, endpoint, body=nil)
    response = RestClient::Request.execute(
      method: verb,
      url: url + endpoint,
      payload: body&.to_json,
      headers: { content_type: :json }
    ).body

    JSON.parse(response)
  rescue JSON::ParserError
    response
  end
end
