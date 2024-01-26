require "json"

class CalendarCard

  def self.from_nodeset nodeset
    nodeset.map do |node|
      new node
    end
  end

  def initialize node
    @node = node
  end

  def anchor
    @anchor ||= @node.at_css("a")
  end

  def day
    @day ||= @node.at_css("a > div.m_calCardHead > div.m_calCardDay")
  end

  def image
    @image ||= @node.at_css("a > div.m_calCardHead > div.m_calCardImage > img")
  end

  def text
    @text ||= @node.at_css("a > div.m_calCardBody > p.m_calCardText")
  end

  def category
    @category ||= @node.at_css("a > div.m_calCardBody > span.m_calCardCat")
  end

  def to_hash
    {
      anchor: {
        href: anchor && anchor["href"],
      },
      day: {
        children: day&.children&.map { |e| { text: e.text } }
      },
      image: {
        src: image && image["src"],
      },
      body: {
        children: text&.children&.map { |e| { text: e.text } },
      },
      category: {
        content: category&.content,
      }
    }
  end

  def to_json state_or_hash = nil
    JSON.generate to_hash
  end

end
