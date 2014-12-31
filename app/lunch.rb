require 'date'
require 'redis'
require 'json'

class LunchManager
  PREFIX = 'slack-lunch'

  attr_reader :key

  def initialize()
    @redis = Redis.new(port: 16379)
  end

  def add(user, restaurant)
    restaurants(user) do |list|
      list << restaurant
    end
  end

  def remove(user, restaurant)
    restaurants(user) do |list|
      list.delete(restaurant)
      list
    end
  end

  def all(user=nil)
    if user.nil?
      Hash[
        all_users.map do |user|
          [user, restaurants(user)]
        end
      ]
    else
      restaurants(user)
    end
  end

  private

  def base_key
    "#{PREFIX}-#{Date.today.to_s}"
  end

  def user_key(user)
    "#{base_key}-#{@user}"
  end

  def restaurants(user = nil, &block)
    add_user(user)
    array(user_key(user), &block)
  end

  def add_user(user)
    all_users do |users|
      users << user unless users.include? user
    end
  end

  def all_users(&block)
    array(base_key, &block)
  end

  def array(key, &block)
    raw = @redis.get(key)
    values = raw.nil? ? [] : JSON.parse(raw)
    return values unless block
    block.call(values)
    @redis.set(key, values)
    values
  end


end
