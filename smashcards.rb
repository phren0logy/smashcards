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
  flow do
    # Title at the top
    stack :height => 50 do
      background green 
      title "SmashCards" 
    end
    # This should be replaced with the flash cards
    @main_window = stack :width => 600, :height => 300, :margin => 20 do
        fill rgb(0, 0.6, 0.9, 0.1)
        stroke rgb(0, 0.6, 0.9)
        strokewidth 0.25
        100.times {
          oval :left => (-5..self.width).rand,
            :top => (-5..self.height).rand,
            :radius => (25..50).rand
          }
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
          @flip_button = button("flip") do
            @side == 1 ? @side = 0 : @side = 1
            #@main_window.background limegreen
            @the_text.replace @data[@card][@side]
          end
          
          @next_button = button("next") do
            @card < (@data.length-1) ? @card += 1 : @card = @data.length-1
            @side = 0
            #@the_text.replace @card
            @the_text.replace @data[@card][@side]
          end
          
          @back_button = button("back") do
            @card > 1 ? @card -=1 : @card = 0
            @side = 0
            @the_text.replace @data[@card][@side]
          end
    end
  end
end
