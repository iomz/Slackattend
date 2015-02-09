require 'open-uri'
require 'addressable/uri'
require 'nokogiri'
require 'natto'

module Slackattend
  class SentimentAnalyzer
    SIGNIGICANT_POS = ['名詞'].freeze
    
    @nm = Natto::MeCab.new('-F%f[0]')
  
    # Query to yahoo realtime search and extract sentiments
    def self.get_sentiment(word)
      pos, neg, neu = 0, 0, 0
      url = "http://realtime.search.yahoo.co.jp/search?ei=UTF-8&p=#{word}"
      doc = Nokogiri::HTML(open(Addressable::URI.parse(url).normalize.to_str))
      doc.xpath('//div[@id="posnegUnitWrap"]/div/a').each do |node|
        case node.attributes["id"].value
        when "positiveBtn"
          pos = node.text[0..-2].to_i
          #p "Positive: #{pos}"
        when "negativeBtn"
          neg = node.text[0..-2].to_i
          #p "Negative: #{neg}"
        end
        neu = 100 - pos - neg
      end
      return {pos=>:positive, neg=>:negative, neu=>:neutral}.max # Returns the most matched sentiment
    end
    
    # Analyze the sentiment of the sentence
    def self.judge(sentence)
      sum = 0
      dist = {:positive => 0, :negative => 0, :neutral => 1}
      @nm.parse(sentence) do |n|
        if SIGNIGICANT_POS.include? n.feature
          s = get_sentiment(n.surface)
          dist[s[1]] += s[0]
        end
      end
      return dist.max_by{|k,v| v} # Retuns the most cumulated sentiment
    end
  end
end

