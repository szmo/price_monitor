require 'nokogiri'
require 'open-uri'

class ItakaParser
    def initialize(url)
        @html = Nokogiri::HTML(open(url))
    end

    def find_price()
        @html.css("strong[data-js-value='offerPrice']")[0].text.strip.gsub("\u00A0", "")
    end

    def find_name()
        @html.css("span[class='productName-holder']")[0].text.strip
    end

    def find_country()
        @html.css("span[class='destination-title destination-country-region']")[0]['data-product-country']
    end

    def find_city()
        @html.css("span[class='destination-title destination-country-region']")[0]['data-product-region']
    end
end
