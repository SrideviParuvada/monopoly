require 'yaml'
require 'pry'
require_relative './classes.rb'
require_relative './modules.rb'
require_relative './supporting/actions.rb'
require_relative './supporting/player.rb'

include Monopoly
DEBUG = ENV['DEBUG'] || false

def log(message)
  puts message if DEBUG
end

begin
  puts "How many players would like to play the game?"
  number_of_players = gets.strip.to_i
  if number_of_players < 1 || number_of_players > 4
    puts "Invalid choice"
  end
end until number_of_players.between?(1, 4)

@players = []

number_of_players.times do |count|
  puts "What is the name of player #{count + 1}?"
  @players << Player.new(gets.strip.to_s)
end

user_input = nil

until exit_text(user_input)
  @players.each { |player|
    if player.in_jail
      jail(player)
    end
    check_player_funds(player)
    if @players.length == 1
       puts "since there is only player left in a game, you are the winner."
       user_input = 'Exit'
    end
    player.has_rolled = false
    player.double_count = 0
    player.is_double = false
    player.rent_payed = false
    turn(player)
  }
end

#HW

# if player's money goes below zero then that player is out of the game - Done
# if there is one player left that player wins - Done
# add the go space or you can add jail (these are not properties) - Done
# with go space, if you pass the go, you have to put 200$ in players's cash - Done
# only when you pass it - done
# when you roll 3doubles, player should go to jail ...and player have to stay in jail until they pay $50 or attempt to roll double
# new space is jail when you managed to roll 3 doubles and player don't move - Done
# If you decided pay 50 instead of going to jail, you get to roll and do normal business - done
# Go is not a space that you can buy - should be handled - done


# HW -1/20/21
# When the person passed 0 element on board array they get 200$ - done
#
# 1/28/21
# If the space is go or jail it should not give option buy - done
# May be throw defaults so they are not required - done
# no need additional class space,BoardSpace should handle it - done
# Change jail space to visiting and make a flag instead? - done
# Jail is a double space - one visiting other is in jail - different rules for these two statuses - done
# Make a spacial method for jail (you will end their turn, not get paid for going around, ) - done
# put rail roads on the board - done
#
# 2/3/21
# divide modules.rb in to separate modules logically - done
# when you first land in jail, you don't have any option but trading and you should be able to end turn - done
# in your next turn,you have option to roll and if you roll double you will get out of jail - done
# Otherwise you can chose to pay 50 $ and get out of jail and roll and conitune play - done
# turn should print valid options ...and there is a method for each action - done
# There should be another to take care valied choice, if user enters wrong choice that should be taken care in this method - done
# Each of these methods should only take player - done
# turn should be called over and over again for the same player ...you moved, now call turn to do next thing in the same turn - I didn't understand this
# bug: in same turn if user have to pay rent twice in case rolling double - Fixed
# pay rent got messed up - fixed

#2/3 - questions
# I'm not sure if  check_player_funds  actually deletes a player and there are morethan 1 one player in the gameif it actually returns to next player ?