require_relative 'github_client.rb'
require_relative 'slack_client.rb'

class GMUDAdvertiser
  REPOSITORIES = %w[recurrent gateway vault backoffice].freeze

  def initialize; end

  def call
    # scan_github_info
    send_notification
  rescue KeyError
    # Não foi possível obter credenciais de acesso
  end

  private

  attr_reader :gmuds_to_notificate

  def scan_github_info
    @gmuds_to_notificate = []

    REPOSITORIES.each do |repository|
      @gmuds_to_notificate << GithubClient.new(repository).call
    end
  end

  def send_notification
    gmuds_to_notificate.reject(&:nil?).each do |gmud|
      SlackClient.new(gmud).call
    end
  end
end
