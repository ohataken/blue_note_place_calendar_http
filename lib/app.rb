# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'uri'
require 'open-uri'
require 'nokogiri'
require './lib/calendar_cache'
require './lib/calendar_card'

get '/api/calendar/:year/:month/:day' do
  origin_host = ENV['ORIGIN_HOST']
  cal = params['year'] + params['month']
  nodeset = CalendarCache.cache cal.to_s do
    uri = URI("#{origin_host}/live/?cal=#{cal}")
    html_doc = Nokogiri::HTML(URI.open(uri))
    html_doc.css('div.calBoardCardsBody > div.c_calBoardCard')
  end

  card = CalendarCard.from_nodeset(nodeset).find do |c|
    c.day == params['day'].to_i
  end

  json card
end
