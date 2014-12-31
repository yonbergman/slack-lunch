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
    channel = request['channel_name']

    text = CommandParser.new.run_command(user, command, channel)
    text
    
  end
end
