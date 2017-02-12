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
        
        puts "begin scraping"
        @link = params[:link]
        all_data = Nokogiri::HTML(open("#{@link}"))
        all_data_text = all_data.xpath("//text()").text
        puts all_data_text
        puts "ended scraping"
        
        #Create a new array of all kanji characters
        kanjiCharacters = Array.new
        all_data_text.each_char do |c|
            
            kanjiCharacters.insert("#{@c}")
        end
        
        
    end
    
end