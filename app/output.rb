require 'json'
require 'httparty'
class Output

  URL = ENV['SLACK_WEBHOOK']

  def self.post(message, channel)
    reply = JSON.generate(username: "lunch-bot", icon_emoji: ":curry:", text: message, channel: channel)
    HTTParty.post(URL, body: reply)
  end

end
