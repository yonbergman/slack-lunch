require 'sinatra'
require_relative './command_parser'

SLACK_TOKEN = ENV['SLACK_TOKEN']

class SlackLunch < Sinatra::Base
  get '/' do
    SLACK_TOKEN
  end

  post '/webhook' do
    return 401 unless request["token"] == SLACK_TOKEN

    user = request['user_id']
    command = request["text"]

    text = CommandParser.new.run_command(user, command)

    response = {username: "lunch-bot", icon_emoji: ":curry:", text: text}
    reply = JSON.generate response

  end
end
