require "sinatra"
require "uri"
require "open-uri"
require "nokogiri"
require "./calendar_cache"
require "./calendar_card"

get "/live/:cal" do
  origin_host = ENV["ORIGIN_HOST"]
  cal = params["cal"]
  uri = URI("#{origin_host}/live/?cal=#{cal}")
  nodeset = CalendarCache.cache cal.to_s do
    html_doc = Nokogiri::HTML(URI.open(uri))
    html_doc.css("div.calBoardCardsBody > div.c_calBoardCard")
  end
  cards = CalendarCard.from_nodeset nodeset
  cards.to_json
end
