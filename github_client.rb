require_relative 'api_client.rb'
require_relative 'pullrequest_parser.rb'

class GithubClient
  include ApiClient

  CREDENTIALS = "#{ENV.fetch('GITHUB_USER')}:#{ENV.fetch('GITHUB_ACCESS_TOKEN')}".freeze

  def initialize(repository)
    @repository = repository
  end

  def call
    PullRequestParser.gmud_hash(last_closed_gmud) if has_valid_gmud?
  end

  private

  attr_reader :repository

  def has_valid_gmud?
    last_closed_gmud&.any? && is_from_today_gmud? && gmud_is_tagged?
  end

  def last_closed_gmud
    @last_closed_gmud ||=
      request(:get, vindi_endpoint, "/pulls?base=production&state=closed")&.first
  end
  
  def vindi_endpoint
    "https://#{CREDENTIALS}@api.github.com/repos/vindi/#{repository}"
  end
  
  def is_from_today_gmud?
    last_closed_gmud.dig('title') == "[GMUD] Release #{Date.today.to_s}"
  end

  def gmud_is_tagged?
    last_closed_gmud.dig('labels').select { |label| label['name'] == 'Aplicado em Produção' }.any?
  end
end
