# frozen_string_literal: true

require 'forwardable'

class CalendarCache
  extend Forwardable

  class << self
    def singleton
      @singleton ||= new
    end

    def cache(key, &block)
      singleton.cache key, &block
    end
  end

  def initialize
    @hash = {}
  end

  delegate :[] => :@hash
  delegate :[]= => :@hash
  delegate key?: :@hash

  def cache(key)
    if key? key
      @hash[key]
    else
      @hash[key] = yield
    end
  end
end
