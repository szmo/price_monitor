require 'nokogiri'
require 'open-uri'

class BasicParser
  def initialize(url, name: nil)
    @name = name.nil? ? URI(url).host : name
    @url = url
    @html = Nokogiri::HTML(open(url))
  end

  def find_in_html(xpath)
    @html.css(xpath)[0].text
  end

  def purify_price(text)
    # FIXME: - period and comma for other currencies
    text = text.strip
    Settings.parser_helpers.things_to_delete.map { |thing| text = text.gsub(Regexp.new(thing), '') }
    text.tr(',', '.')
  end

  def purify_text(text)
    text.strip
  end

  def parse
    result = { url: @url, provider: @name }
    Settings.parsers[@name].number.each do |property, xpath|
      result[property] = purify_price(find_in_html(xpath))
    end
    Settings.parsers[@name].string.each do |property, xpath|
      result[property] = purify_text(find_in_html(xpath))
    end
    Deal.new(**result)
  end
end
