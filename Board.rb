module Dice
  def dice_roll
    flag = nil
    num1 = rand(1..6)
    num2 = rand(1..6)
    puts "Dice 1: #{num1}"
    puts "Dice 2: #{num2}"
    total_roll = num1+num2
    puts "Dice roll: #{total_roll}"
    if num1 == num2
      flag = true
    end
    return total_roll, flag
  end
end

class Space
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

class Property < Space
  attr_reader :value
  def initialize(value, name)
    @value = value
    super(name)
  end
end

class Board
  attr_reader :spaces
  def initialize
    @spaces = []
    create_board
  end
  def create_board
    properties_hash.each do |name, value|
       @spaces << Property.new(value, name.to_s)
    end
  end
  def properties_hash
     {'Mediterranean Avenue': 60,
      'Baltic Avenue': 60,
      'Oriental Avenue': 100,
      'Vermont Avenue': 100,
      'Connecticut Avenue': 120,
      'St.Charles Place': 140,
      'States Avenue': 140,
      'Virginia Avenue':160 ,
      'St. James Place':180 ,
      'Tennessee Avenue': 180,
      'New York Avenue': 200,
      'Kentucky Avenue': 220,
      'Indiana Avenue': 220,
      'Illinois Avenue':240,
      'Atlantic Avenue':260,
      'Ventnor Avenue':260,
      'Marvin Gardens':280,
      'Pacific Avenue':300,
      'North Carolina Avenue':300,
      'Pennsylvania Avenue':320,
      'Park Place':350,
      'Boardwalk':400}
  end
end

class Player
  attr_accessor :location, :name, :cash, :player_properties
  include Dice
  def initialize(name)
    @location = 0
    @name = name
    @cash = 1500
    @player_properties = Array.new
  end
  # def move(board_size)
  #   total_roll, is_double = dice_roll
  #   #dice2 = dice_roll
  #   @location = @location + total_roll
  #   #dice2 = dice_roll
  #   #@location = @location + dece1 + dice2
  #   if  @location.to_i >= board_size
  #     @location =  @location - board_size
  #   end
  #   return total_roll, is_double
  # end
end

class Turn
  attr_reader :current_position, :final_position
  include Dice
  def initialize
    @current_position
    @final_position
  end
  def move(board_size, current_position)
    @current_position = current_position
    @final_position = 0
    is_double = nil
    total_roll, is_double = dice_roll
    @final_position = @current_position +  total_roll
    if  @final_position.to_i >= board_size
      @final_position =  @final_position - board_size
    end
    return @final_position, is_double
  end
  def buy(properties, property_name, property_value, player_properties, player_cash)
      properties.delete(property_name)
      player_cash =  player_cash - property_value
      player_properties << property_name
      return properties, player_properties, player_cash
  end
end

class Bank
  attr_reader :cash_bank_has
  def initialize
      @cash_bank_has = 25000
  end
  def bank_gets(add_to_bank)
    @cash_bank_has = @cash_bank_has + add_to_bank
  end
  def bank_gives(subtract_to_bank)
    @cash_bank_has = @cash_bank_has - subtract_to_bank
  end
end

players = []
player_turn = Turn.new
bank = Bank.new
puts "How many number of players would like to play the game? "
number_of_players = gets.strip.to_i
counter = 0
while counter < number_of_players
   puts "what is player's name?"
   name = gets.strip
   players << Player.new(name)
   counter = counter + 1
end

board = Board.new
@available_properties = Array.new
puts "Available properties buy"
board.spaces.each{|space|
  @available_properties << space.name
}
user_input = nil
until user_input == 'n'
  players.each{ |player|
    user_input1 = nil
    user_input2 = nil
    user_input3 = nil
    until user_input1 == 'n'
      puts "#{player.name}'s position is '#{player.location.to_i}' and is on property '#{board.spaces[player.location.to_i].name}' and has #{player.cash} cash"
      puts "#{player.name} is rolling the dice"
      player.location, is_double = player_turn.move(board.spaces.size, player.location)
      puts "#{player.name}'s position is '#{player.location.to_i}' and is on property '#{board.spaces[player.location.to_i].name}' and has #{player.cash} cash"
      if @available_properties.include?(board.spaces[player.location.to_i].name)
        puts "#{player.name}, the property you are on is '#{board.spaces[player.location.to_i].name}', it is available to buy, it costs '#{board.spaces[player.location.to_i].value}', and you have #{player.cash} cash, do you want to buy this property? y/n"
        user_input3 = gets.strip
        if user_input3 =='y'
          @available_properties, player.player_properties, player.cash = player_turn.buy(@available_properties, board.spaces[player.location.to_i].name, board.spaces[player.location.to_i].value, player.player_properties, player.cash)
          puts "#{player.name}, now you own #{player.player_properties} and you still have cash #{player.cash}"
        end
      end
      if (is_double)
        puts "Since it is double, #{player.name}, you want to roll again? y/n"
        user_input2 = gets.strip
        if user_input2 == 'y'
          player.location, is_double = player_turn.move(board.spaces.size, player.location)
          puts "#{player.name}, the property you are on is '#{board.spaces[player.location.to_i].name}', it is available to buy, it costs '#{board.spaces[player.location.to_i].value}', and you have #{player.cash} cash, do you want to buy this property? y/n"
          user_input3 = gets.strip
          if user_input3 =='y'
              @available_properties, player.player_properties, player.cash = player_turn.buy(@available_properties, board.spaces[player.location.to_i].name, board.spaces[player.location.to_i].value, player.player_properties, player.cash)
              puts "#{player.name}, now you own #{player.player_properties} and you still have cash #{player.cash}"
          end
        end
      end
      puts "#{player.name}, you want to roll again? y/n"
      user_input1 = gets.strip
    end
  }
  puts "You guys want to continue playing? y/n"
  user_input = gets.strip
end

players.each{ |player|
  puts "At the end of the game #{player.name} have #{player.player_properties} and #{player.cash} cash"
}

#direction: pass the the player to method turn, stay in that method and do everything (right now is just move)
# in the method we collect user's input and that input should be the return value for the method  - input should be done or keep going
# If the person rolls double, from the with in the method, it should call itself - method should call itself - Recurrsive method
#



# - Next class
# --Read one more chapter (5)


#Homework: when you roll double, you move it again - Done
# when it is dounble, user should press enter to roll the dice, it shouldn't be automatic - done
# Homework: in until loop, player 1 to 4 gets a turn and they roll the dice and print out, which player at what location, when they type exit - Done
#player, should already know about player's position, so make use of that instead of externally capturing it in a hash - Done
#When all the players finished round 1, it should go back to player 1 and keep going - nested while loop might work - Done

# 1. When pressed enter, it is not telling who is rolling - Done
#2. When it is double, it is adding to previous roll, it shouldn't, because we should move, buy, whatetver and the we will roll again, it should be treated as a second - Done
#3. should print before the roll and after the roll - Done

# 4. Not able to exit any time I want, only after all players are done, so change that to exist whenever you want
#if it is double in double it is not letting player roll again - needs to solve













