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
    
    def print_score
        puts case params[:average]
            when 0.0..4.9
                @comment = "<div>Seems easy! Even an <b>N5</b> vocab level should be enough!</div>".html_safe
            when 5.0..24.9
                @comment = "<div>This shouldn't be too hard. An <b>N4</b> vocabulary will get you through it!</div>".html_safe
            when 25.0..49.9
                @comment = "<div>A bit more difficult. You'll want to study some <b>N3</b> terms to fully understand this.</div>".html_safe
            when 50.0..74.9
                @comment = "<div>This one's a challenge. Readers will need <b>N2</b> vocabulary.</div>".html_safe
            when 75.0..100.0
                @comment = "<div>This is for experienced students only. <b>N1</b> vocabulary is needed to read this.</div>".html_safe
        end
        
        @average_score = "<div>#{params[:average]}%</div>".html_safe
    end
    
    def getURLText
        
        jlpt_sum = 0;
        
        puts "begin scraping"
        @link = params[:link]
        all_data = Nokogiri::HTML(open("#{@link}"))
        all_data_text = all_data.xpath("//text()").text
        puts "ended scraping"
        
        #Create a new array of all kanji charactersruby html
        kanjiCharacters = Array.new
        all_data_text.split('').each do |c|
            if(c.ord >= 0x4e00 && c.ord <= 0x9faf)
                kanjiCharacters.push(c)
            end
        end
        
        50.times do |n|
            char_uni = kanjiCharacters[n]
            url_string = URI::encode(char_uni)
            jisho_page = Nokogiri::HTML(open("http://jisho.org/search/#{url_string}%23kanji"))
            jlpt = jisho_page.css('.jlpt>strong').text
            jlpt_level = jlpt[1]
            jlpt_sum = jlpt_sum + jlpt_level.to_f
        end
        average_score = (jlpt_sum/2000) * 100
        puts average_score
        params[:average] = average_score
        
        self.print_score
    end
end