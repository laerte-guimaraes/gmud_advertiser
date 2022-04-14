require_relative 'github_client.rb'
require_relative 'slack_client.rb'

class GMUDAdvertiser
  def initialize(webhook)
    @webhook = webhook
  end

  def call
    send_notification
  rescue KeyError
    # Não foi possível obter credenciais de acesso
  end

  private

  attr_reader :webhook

  def send_notification
    SlackClient.new(gmud).call
  end

  def gmud
    GithubClient.new(webhook).call
  end
end
