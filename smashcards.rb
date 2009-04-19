#
#  SmashCards
#
#  Created by Andrew Nanton on 2009-04-19.
#  Copyright (c) 2009. All rights reserved.
#

Shoes.setup do
	#source 'http://code.whytheluckystiff.net'
	#gem 'gemname'
end

#require 'gemname'

Shoes.app do
  flow  do
    stack :height => 150 do title "SmashCards" end
      stack :width => 600, :height => 300, :margin => 50 do
        para "You can open a flashcard file here, by chosing open below. ",
        "You will need a file in csv (or comma separated value) format, ",
        "with one line per flashcard, and the front and back separated by a comma."
        stack :height => 150 do
          button("open") {csvfile = ask_open_file}
        end
      end
  end
end
