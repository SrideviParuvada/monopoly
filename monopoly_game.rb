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

  def printing
    puts "Player is on: #{@property_name} and it's value is: #{@property_value} and owned by: #{@property_owner} "
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
  attr_accessor :player_position, :player_cash, :player_owns
  def initialize(name)
    @name = name
    @player_position = 0
    @player_cash = 500
    @player_owns = []
  end
  def player_turn(board)
    #puts "user position"
    #position = gets.strip.to_i

  end
end

# HW - 9/11 - Create a method that takes a single argument, I want you to tell me all the properties owned by a single player and this method takes player  as input and returns array of properties that player owns
# Then probably we don't need player_owns

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

def move_player(player:, roll:)
  next_player = true
  #change the out put of roll to return hash instead of array
  # probably doesn't need to assign values to move and double as they are used only once
  move = roll[0]
  double = roll[1]
  #move will eventually contains both space name to move to or total dice roll and if it is name of the space, following line will get exercised to identify index of the space
  found_space = BOARD.find_index { |space| space.property_name == move }
  #if space name is not found, that means move has total dice role and will enter in to below if loop
  if found_space.nil?
    number_of_spaces = move.to_i
    if number_of_spaces <= 0 || number_of_spaces > BOARD.length
      puts "Invalid parameter: #{move}"
      next_player = false
    else
      player.player_position += number_of_spaces
       if player.player_position  > BOARD.length-1
          player.player_position -= BOARD.length
       end
       if double
          next_player = false
       end
    end
  else
    player.player_position = found_space
  end
  BOARD[player.player_position].printing
  next_player
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
  #not sure if this is the right spot to print players' status position before exiting
  # players.each { |player|
  #   puts "At the end of the game #{player.name} owns #{player.player_owns} and remaining cash player has is: #{player.player_cash}"
  # }
  exit if user_input.to_s.strip.downcase == 'exit'
end

user_input = nil
until exit_text(user_input)
  players.each { |player|
    # This begin loop will run till user enters the right input if incase invalid value is entered
    begin
      puts "#{player.name}, enter exit to stop the game or press enter to start rolling the dice"
      user_input = gets.strip
      exit_text(user_input)
      #we are passing output of roll method as a param to move_player
    end until move_player(player:player, roll:roll)
    # probably move this if loop in to do while loop, above
    # See if buy can handle all of these below transactions or create a separate method 
    if BOARD[player.player_position].property_owner == 'Banker'
      if player.player_cash >= BOARD[player.player_position].property_value
         puts "#{player.name}, you are on #{BOARD[player.player_position].property_name} and it's value is #{BOARD[player.player_position].property_value} and it is available for buying, you have #{player.player_cash}, you want to buy this property?"
         user_choice = gets.strip
         if user_choice.downcase == 'yes'
           player.player_cash = buy_property(player.player_cash,BOARD[player.player_position].property_value)
           BOARD[player.player_position].property_owner = player.name
           player.player_owns << BOARD[player.player_position].property_name
           BOARD[player.player_position].printing
         end
         end
    end
    puts "All properties #{player.name} own: #{player.player_owns}"
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
