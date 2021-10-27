require 'pry'
require 'yaml'

Dir.glob(File.join(File.dirname(__FILE__), 'support_game', '*.rb'), &method(:require))

include Menu

option = menu(options: ['New Game', 'Load Game', 'Exit Game'],
              title: 'Please choose one of the options to start the game')

BOARD = send option

@players.cycle do |player|
  @current_turn ||= NewTurn.new(player: player)
  turn(@current_turn)
  @current_turn = nil
end





# #hw: 10/20
#it showing load game when there is no saved game - on right track, fix until, it should onl get out of loop when they enter unique name - done
# #work on rent don't worry about manage properties yet - done
# implement the logic so that players names are unique - done

#bug
# Rent seems to be not adding to other player
# Not able to push