require 'yaml'
require 'pry'
#binding.pry

class Property
  attr_reader :property_name, :property_value
  attr_accessor :property_owner
  def initialize(name:, value:, **options)
    @property_name = name
    @property_value = value
    @property_owner = 'Banker'
  end
end

def create_properties(spaces)
  board = []
  spaces.each_value do |value|
    board << Property.new(**value)
  end
  board
end

def create_board
  spaces = YAML.load_file('Board.yml')
  spaces.transform_keys!(&:to_sym)
  spaces.each_value do |value| value.transform_keys!(&:to_sym)
  end
  create_properties(spaces)
end

BOARD = create_board

class Player
  attr_reader :name
  attr_accessor :player_position, :player_cash
  def initialize(name)
    @name = name
    @player_position = 0
    @player_cash = 500
  end
end

# HW - 9/11 - Create a method that takes a single argument, I want you to tell me all the properties owned by a single player and this method takes player  as input and returns array of properties that player owns - Done
# Then probably we don't need player_owns - Done

def printing(player_name)
  properties_owned_by_player = []
  BOARD.each do |board|
    if board.property_owner == player_name
      properties_owned_by_player << board.property_name
    end
  end
  puts "Player #{player_name} owns: #{properties_owned_by_player}"
end

def roll
  is_double = false
  puts "Enter first dice roll"
  num1 = gets.strip.to_i
  puts "Enter second dice roll"
  num2 = gets.strip.to_i
  puts "Dice 1: #{num1}"
  puts "Dice 2: #{num2}"
  total_roll = num1+num2
  puts "Dice roll: #{total_roll}"
  is_double = true if num1 == num2
  [total_roll, is_double]
end

def move_player(player:, move:)
  player.player_position += move.to_i
  if player.player_position  > BOARD.length-1
     player.player_position -= BOARD.length
  end
end

def buy_property(player_has, value)
  player_has -= value
end

puts "How many players would like to play the game?"
number_of_players = gets.strip.to_i
players = []

number_of_players.times do |count|
  puts "What is the name of player #{count+1}?"
  players << Player.new(gets.strip.to_s)
end

def exit_text(user_input)
  exit if user_input.to_s.strip.downcase == 'exit'
end

def turn (player)
  puts "#{player.name}, enter exit to stop the game or press enter to start rolling the dice"
  user_input = gets.strip
  exit_text(user_input)
  roll_output = roll
  move_player(player:player, move:roll_output[0])
  player_options(player)
  roll_output[1]
end

def player_options(player)
  if BOARD[player.player_position].property_owner == 'Banker'
    if player.player_cash >= BOARD[player.player_position].property_value
      puts "#{player.name}, you are on #{BOARD[player.player_position].property_name} and it's value is #{BOARD[player.player_position].property_value} and it is available for buying, you have #{player.player_cash}, you want to buy this property?"
      user_choice = gets.strip
      if user_choice.downcase == 'yes'
        player.player_cash = buy_property(player.player_cash,BOARD[player.player_position].property_value)
        BOARD[player.player_position].property_owner = player.name
      end
    end
  else
    puts "#{player.name}, you are on #{BOARD[player.player_position].property_name} and it is not available for buying."
  end
end

user_input = nil
until exit_text(user_input)
  players.each { |player|
      is_double = true
      begin
        is_double = turn(player)
      end until is_double == false
      printing(player.name)
   }
end

#homework 8/31
# 1. Change the interface so it takes dice roll as input for move instead of feeding values - Done
# 2. Enter 1st dice and what not in roll - Done
# 3. Handle double - Done
# 4. Property should know who owns this property, name of the person
# 5. Add in ability to purchage a property, "hey it is your turn, this is how much you have, you are on this property, and this property is available for buying", you wanna buy?"" - a lot - Buy should be a mothod, it should adjust instance of the property
#Home work for Chris to write couple of unit tests for this so we I can add more unit tests
# issues
# 1. If it is double, player is not prompted for the buy option
#    I think double logic should come out of move and move should just take numbers and move the player without handleing any logic
#    until loop should handle double, if it is double, user should be able to roll the dice again and call move again


# homework 8/24
# 1. Give the which player is playing right now - done
# 2. HARD - If player doesn't move, should stay on that player and give opportunity to correct their input - done
# 3. print property value - done
# 4. print names of players as well
#

# homework 8/17
# add another player and move both players


# use spaces to create the array of space objects - Done
# review factories in the the book - Done
# hint: take spaces and pass it to a method, that will return an array of spaces objects - done
# Fill the rest of the yml with rest of the properties -Done
# Move the player on the board - Done
# Create player class - Player knows where they are on the board, no need for roll yet, we just ask player, where you are, we should get an answer ..not move yet - Done
# player position is 3, and player should take that and print where he is - Done
#to do give me a space name  - Home work - Done
# I want to say move player to Board Walk, will only provider space name, you need to figure how to get there, by calculation - Done
# Add validation for correct space name as well - Done
# Player should not allowed to move back wards - Home work - either use absolute method to make number always positive, what if they enter 3.5, you can throw an exception - Different ways to do it
# If you enter any invalid value, multiple options, you drive them to make a right a choice?
#
#

# next thing we will be working on is buy, player should be dealing with cash, subtract the amunt from player when buy happens
# Go over TDD and how to write tests before you actually implement the code
# Write few test for this program
# Given a player
# When they roll the dice
# Then they move that many spaces forward
# #Describe your problem, encapsulate make a game, board classes
#
