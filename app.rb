require "sinatra"
require "sinatra/json"
require "uri"
require "open-uri"
require "nokogiri"
require "./calendar_cache"
require "./calendar_card"

get "/calendar/:year/:month" do
  origin_host = ENV["ORIGIN_HOST"]
  cal = params["year"] + params["month"]
  nodeset = CalendarCache.cache cal.to_s do
    uri = URI("#{origin_host}/live/?cal=#{cal}")
    html_doc = Nokogiri::HTML(URI.open(uri))
    html_doc.css("div.calBoardCardsBody > div.c_calBoardCard")
  end
  cards = CalendarCard.from_nodeset nodeset
  json cards
end
