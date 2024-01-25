require "sinatra"
require "uri"
require "open-uri"
require "nokogiri"

get "/live/:cal" do
  origin_host = ENV["ORIGIN_HOST"]
  cal = params["cal"]
  uri = URI("#{origin_host}/live/?cal=#{cal}")
  html_doc = Nokogiri::HTML(URI.open(uri))
  cards = html_doc.css("div.calBoardCardsBody > div.c_calBoardCard")

  days = cards.map do |card|
    a = card.at_css("a")
    day = card.at_css("a > div.m_calCardHead > div.m_calCardDay")
    image = card.at_css("a > div.m_calCardHead > div.m_calCardImage > img")
    body = card&.at_css("a > div.m_calCardBody > p.m_calCardText")
    cat = card.at_css("a > div.m_calCardBody > span.m_calCardCat")

    {
      a_href: a && a["href"],
      day_content: day&.content,
      image_src: image && image["src"],
      body_content: body&.content,
      cat_content: cat&.content,
    }
  end

  days.to_json
end
