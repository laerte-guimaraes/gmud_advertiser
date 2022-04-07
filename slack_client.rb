require_relative 'api_client.rb'

class SlackClient
  include ApiClient

  ENDPOINT = "#{ENV.fetch('SLACK_ENDPOINT')}".freeze

  def initialize(gmud_hash)
    @gmud_hash = gmud_hash
  end

  def call
    post_notification(
      'https://hooks.slack.com/services/',
      ENDPOINT,
      { 'text': slack_message }.to_json
    )
  end

  private

  attr_reader :gmud_hash

  def slack_message
    <<-SLACK_MESSAGE
<#{gmud_hash[:link]}|*#{gmud_hash[:repository]} - GMUD #{gmud_hash[:number]}*>

*O que mudou* :repeat:
#{gmud_hash[:changes]}

*Riscos* :warning:
#{gmud_hash[:riskiness]}
    SLACK_MESSAGE
  end
end
