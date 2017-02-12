require 'nokogiri'
require 'open-uri'

class PagesController < ApplicationController
    def home
        @link = Link.new
    end
    
    def create
        @link = Link.new(link_params)
        @link.getURLText
    end
    
    def link_params
        params.require(:link).permit(:url)
    end
    
    def getURLText
        
        jlpt_sum = 0;
        
        puts "begin scraping"
        @link = params[:link]
        all_data = Nokogiri::HTML(open("#{@link}"))
        all_data_text = all_data.xpath("//text()").text
        puts "ended scraping"
        
        #Create a new array of all kanji characters
        kanjiCharacters = Array.new
        all_data_text.split('').each do |c|
            if(c.ord >= 0x4e00 && c.ord <= 0x9faf)
                kanjiCharacters.push(c)
            end
        end
        puts kanjiCharacters.length
        
        25.times do |n|
            char_uni = kanjiCharacters[n]
            url_string = URI::encode(char_uni)
            jisho_page = Nokogiri::HTML(open("http://jisho.org/search/#{url_string}%23kanji"))
            jlpt = jisho_page.css('.jlpt>strong').text
            jlpt_level = jlpt[1]
            jlpt_sum = jlpt_sum + jlpt_level
        end
        
    end
    
end