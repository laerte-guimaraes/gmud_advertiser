require_relative 'pullrequest_parser.rb'

class GithubClient
  def initialize(webhook)
    @webhook = webhook
  end

  def call
    PullRequestParser.gmud_hash(pull_request) if has_valid_gmud?
  end

  private

  attr_reader :webhook, :pull_request

  def has_valid_gmud?
    gmud_is_tagged? && is_closed_gmud?
  end

  def gmud_is_tagged?
    webhook.dig('action') == 'labeled' &&
      pull_request.dig('labels').select do |label|
        label['name'] == 'Aplicado em Produção'
      end.any?
  end

  def is_closed_gmud?
    pull_request.dig('state') == 'closed'
  end

  def pull_request
    @pull_request ||= webhook.dig('pull_request')
  end
end
