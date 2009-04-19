#
#  SmashCards
#
#  Created by Andrew Nanton on 2009-04-19.
#  Copyright (c) 2009. All rights reserved.
#

Shoes.setup do
	#source 'http://fastercsv.rubyforge.org'
	#gem 'fastercsv'
end

require 'csv'

Shoes.app do
  def circles
    fill rgb(0, 0.6, 0.9, 0.1)
    stroke rgb(0, 0.6, 0.9)
    strokewidth 0.25
    100.times do
      oval :left => (-5..self.width).rand,
        :top => (-5..self.height).rand,
        :radius => (25..50).rand
      end
  end
  
  def stars
    fill rgb(255, 215, 0, 0.1)
    stroke goldenrod
    strokewidth 0.25
    50.times do
      star :left => (-5..self.width).rand,
        :top => (-5..self.height).rand,
        :points => (5..8).rand
      end
  end
  
  flow do
    # Title at the top
    stack :height => 50 do
      background gradient(black, gray) 
      title "SmashCards", :stroke => tomato
    end
    
    # This should be replaced with the flash cards
    @main_window = stack :width => 600, :height => 300, :margin => 20 do
      circles
      @the_text = para "You can open a flashcard file here, by chosing open below. ",
      "You will need a file in csv (or comma separated value) format, ",
      "with one line per flashcard, and the front and back separated "
      "by a comma."
    end
    
    @open_stack = stack :height => 30, :width => 600 do
          @open_button = button("open") do
            @csv_file = ask_open_file()
            para @csvfile
            @data = CSV.read(@csv_file)
            @the_text.replace "OK, click the flip button to start"
            @card = 0
            @side = 1
            @open_stack.remove
          end
    end

    @card_navigator_stack = flow :height => 30, :width => 600 do
      def change_background
        if @side == 1
          @main_window.clear do
            stars
            @the_text = para @data[@card][@side]
            @the_text.align = 'center'
          end
        else
          @main_window.clear do
            circles
            @the_text = para @data[@card][@side]
            @the_text.align = 'center'
          end
        end
      end
      
      def flip_card
        @side == 1 ? @side = 0 : @side = 1
        change_background
      end
      
      def next_card
        @card < (@data.length-1) ? @card += 1 : @card = @data.length-1
        @side = 0
        change_background
      end
      
      def previous_card
        @card > 1 ? @card -=1 : @card = 0
        @side = 0
        change_background
      end
      
      # Buttons and keys to navigate using the functions
      # defined above.
      @flip_button = button("flip") do
        flip_card
      end
          
      @next_button = button("next") do
        next_card
      end
      
      @back_button = button("back") do
        previous_card
      end
      
      keypress do |key|
        case key
        when "f"    : flip_card
        when " "    : flip_card
        when :up : flip_card
        when :down  : flip_card
        when "b"    : previous_card
        when :up    : previous_card
        when "n"    : next_card
        when :down  : next_card
        else flip_card
        end
      end
      
    end
  end
end
