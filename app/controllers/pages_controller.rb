require 'nokogiri'
require 'open-uri'

class PagesController < ApplicationController
    def home
    end
    
    def getURLText
       all_data = Nokogiri::HTML(open("#{link}"))
       all_data_text = all_data.xpath("//text()").text
       puts all_data_text
    end
    
end