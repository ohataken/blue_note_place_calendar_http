require "forwardable"

class CalendarCache
  extend Forwardable

  class << self
    def singleton
      @singleton ||= new
    end

    def cache key, &block
      singleton.cache key, &block
    end
  end

  def initialize
    @hash = {}
  end

  delegate :[] => :@hash
  delegate :[]= => :@hash
  delegate :has_key? => :@hash

  def cache key
    if has_key? key
      @hash[key]
    else
      @hash[key] = yield
    end
  end
end
