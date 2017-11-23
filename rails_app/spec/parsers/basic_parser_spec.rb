require 'rails_helper'
require 'webmock/rspec'

RSpec.describe BasicParser do
  before(:each) do
    @mock_url = 'http://mock-service-url.mock/'
    stub_request(:get, @mock_url)
      .to_return(status: 200, body: File.new("#{Rails.root}/spec/parsers/example.html").read)
    @parser = BasicParser.new(@mock_url)
  end
  
  describe '.initialize' do
    it 'calculates name from hostname, parses html' do
        expect(@parser.instance_variable_get('@url')).to eql(@mock_url)
        expect(@parser.instance_variable_get('@name')).to eql('mock-service-url.mock')
        expect(@parser.instance_variable_get('@html')).not_to be_nil
    end

    it 'passess name to instance variable' do
        parser = BasicParser.new(@mock_url, name: 'mock-name')
        expect(parser.instance_variable_get('@name')).to eql('mock-name')
    end
  end

  describe '.find_in_html' do
    it 'finds title by passed xpath' do
        mock_xpath_1 = 'p[@class="offer-name"]'
        expect(@parser.find_in_html(mock_xpath_1)).to eql('   Awesome offer ')
    end
  end

  describe '.purify_text' do
    it 'trims text and returns' do
      expect(@parser.purify_text(" \n  \r   mock-text\n\r")).to eql('mock-text')
    end
  end

  describe '.purify_price' do
    it 'trims price and returns' do
      expect(@parser.purify_price('14,99')).to eql('14.99')
      expect(@parser.purify_price('    1911,99 zł')).to eql('1911.99')
      expect(@parser.purify_price('zł 1911,99 pln')).to eql('1911.99')
    end
  end

  describe '.parse' do
    it 'parses given html and returns deal object' do
      result = @parser.parse
      expect(result.name).to eql('Awesome offer')
      expect(result.price).to eql(1911)
    end
  end
end
