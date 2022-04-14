require_relative 'gmud_advertiser.rb'

def lambda_handler(event:, context:)
    webhook = JSON.parse(event.dig('body'))

    GMUDAdvertiser.new(webhook).call

    { statusCode: 200 }
end
