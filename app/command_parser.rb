require_relative './lunch'
require_relative './output'
class CommandParser

  def initialize
    @lunch = LunchManager.new
  end

  def run_command(user, text, channel)
    @user = user
    @channel = channel
    parts = text.downcase.split(/\s/)
    @command = parts.first
    @args = parts.slice(1..-1)
    case @command
      when 'add' then add_restaurant
      when 'remove' then remove_restaurant
      when 'me' then print_my_lunch
      when 'all' then print_current_lunch
      else print_current_lunch
    end
  end

  def add_restaurant
    restaurant = @args.join(" ")
    @lunch.add(@user, restaurant)
    "Added #{restaurant}"
  end

  def remove_restaurant
    restaurant = @args.join(" ")
    @lunch.remove(@user, restaurant)
    "Removed #{restaurant}"
  end

  def print_my_lunch
    arr = @lunch.all(@user)
    if arr.empty?
      "You don't have any restaurants set yet"
    else
      (["You said you want to eat at one of these places:"] + arr).join("\n")
    end
  end

  def print_current_lunch
    Output.post "People want #{@lunch.all.inspect}", @channel
    ""
  end


end
