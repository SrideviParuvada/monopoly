module Monopoly
  extend self
  require 'yaml'

  def create_properties(spaces)
    board = []
    spaces.each_value do |value|
      board << Property.new(**value)
    end
    board
  end

   def create_board(file='Board.yml')
    spaces = YAML.load_file(file)
    # puts "Spaces: #{spaces}"
    spaces.transform_keys!(&:to_sym)
    spaces.each_value { |value| value.transform_keys!(&:to_sym) }
    # puts "Space: #{spaces}"
    create_properties(spaces)
  end

  BOARD = create_board

  def properties_owned_by_player(player_name)
    properties_owned_by_player = []
    BOARD.each do |board|
      if board.owner == player_name
        properties_owned_by_player << board.name
      end
    end
    puts "Player #{player_name} owns: #{properties_owned_by_player}"
    properties_owned_by_player
  end

  def roll(min:1, max:6)
    num1 = rand(min..max)
    num2 = rand(min..max)
    puts "Dice 1: #{num1}"
    puts "Dice 2: #{num2}"
    total_roll = num1+num2
    puts "Dice roll: #{total_roll}"
    # if num1 == num2 then set double to true
    {dice_roll: total_roll, is_double: num1 == num2 }
  end

  def move_player(player:, move:)
    player.position += move.to_i
    if player.position  > BOARD.length-1
      player.position -= BOARD.length
    end
    players_current_information(player)
    players_options(player: player)
    puts "Please pick one of the options available for you #{player.name}"
    user_input = gets.strip
    actions(action: user_input, player: player)
  end

  def players_options(player:)
    name = player.name
    cash = player.cash
    property_value = BOARD[player.position].value
    owner = BOARD[player.position].owner
      if owner == 'Banker'
        if cash >= property_value
          puts "Available actions are:"
          puts "1: Buy"
          puts "2: End Turn"
          puts "3: Stop Game"
          puts "4: Roll"
        end
      else if owner !=name
             puts "#{owner} owns the property you are currently on #{name} so you have to pay rent"
             puts "Available actions are:"
             puts "3: Stop Game"
             puts "5: Pay rent"
           else
             puts "Available actions are:"
             puts "2: End Turn"
             puts "3: Stop Game"
             puts "4: Roll"
           end
      end
  end

  def buy_property(player)
    player.cash -= BOARD[player.position].value
    BOARD[player.position].owner = player.name
  end

  def actions(action:, player:)
    case action.to_i
    when 1
      buy_property(player)
    when 2
      puts "in end turn"
    when 3
      exit_text(exit)
    when 4
      roll_output = roll
      move_player(player: player, move: roll_output[:dice_roll])
      if roll_output[:is_double]
        puts "it is double so rolling again: #{roll_output[:is_double]}"
        actions(action: 4, player: player)
      end
    else
      puts "Invalid input"
    end
  end

  def players_current_information(player)
    #Below command should clear the board before displaying next puts statement but it is not working as anticipated
    system 'clear'
    puts "Current player: #{player.name}  has cash:#{player.cash}  and is on position: #{BOARD[player.position].name}  which costs: #{BOARD[player.position].value} and this property owned by: #{BOARD[player.position].owner}"
  end

  def turn (player)
    begin
      players_current_information(player)
      properties_owned_by_player(player.name)
      players_options(player: player)
      puts "Please pick one of the options available for you #{player.name}"
      user_input = gets.strip
      actions(action: user_input, player: player)
    end until (user_input.to_i == 2 || user_input.to_i == 3)
  end

  def exit_text(user_input)
    exit if user_input.to_s.strip.downcase == 'exit'
  end
end