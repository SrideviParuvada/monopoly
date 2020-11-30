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
    spaces.transform_keys!(&:to_sym)
    spaces.each_value { |value| value.transform_keys!(&:to_sym) }
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
    if num1 == num2
      puts "It's a double"
      is_double = true
    else
      is_double = false
    end
      #{dice_roll: total_roll, is_double: num1 == num2 }
    {dice_roll: total_roll, is_double: is_double }
  end

  def move_player(player:, move:)
    player.position += move.to_i
    if player.position  > BOARD.length-1
      player.position -= BOARD.length
    end
  end

  def players_options(player:, has_rolled:, is_double: )
    property_value = BOARD[player.position].value
    owner = BOARD[player.position].owner
    options = ['End Game']
    options << 'Buy' if owner == 'Banker' and player.cash >= property_value
    options << 'Roll' unless has_rolled
    options << 'End Turn' if (has_rolled && !is_double)
    options << 'Skip Buying' if (has_rolled && is_double)
    puts "#{player.name}, you have following options to chose from"
    options.each_with_index do |value, index|
      puts "#{index+1}:#{value}"
    end
    options
  end

  def buy_property(player)
    player.cash -= BOARD[player.position].value
    BOARD[player.position].owner = player.name
  end

  def actions(action:, player:, available_options:)
    case available_options[action.to_i-1]
    when 'Buy'
      buy_property(player)
    when 'End Turn'
      puts "in end turn"
    when 'End Game'
      exit_text(exit)
    when 'Roll'
      is_double = nil
      until (is_double == false)
        roll_output = roll
        is_double = roll_output[:is_double]
        move_player(player: player, move: roll_output[:dice_roll])
        players_current_information(player: player)
        options = players_options(player:player, has_rolled:true, is_double:is_double )
        puts "Please pick one of the options, enter number"
        user_input = gets.strip
        actions(action: user_input, player: player, available_options: options)
      end
    when 'Skip Buying'
      puts "In skip buying"
    else
      puts "Invalid input"
    end
  end

  def players_current_information(player: )
    #Below command should clear the board before displaying next puts statement but it is not working as anticipated
    system 'clear'
    puts  "Current player:            #{player.name}
    Has:                   $#{player.cash}
    Is on:                 #{BOARD[player.position].name}
    Which costs:           #{BOARD[player.position].value}
    this property owned by:#{BOARD[player.position].owner}"
  end

  def turn (player)
    begin
      players_current_information(player: player)
      properties_owned_by_player(player.name)
      options = players_options(player: player, has_rolled: false, is_double: nil)
      begin
        puts "Please pick one of the options available for you #{player.name}"
        user_input = gets.strip
        if user_input.to_i < 1 || user_input.to_i > options.length+1
          puts "Invalid choice"
        end
      end until user_input.to_i.between?(1, options.length+1)
      actions(action: user_input, player: player, available_options: options)
    end until (user_input.to_i == 2 || user_input.to_i == 3)
  end

  def exit_text(user_input)
    exit if user_input.to_s.strip.downcase == 'exit'
  end
end
