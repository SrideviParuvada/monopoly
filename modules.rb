module Monopoly

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
    spaces.each_value { |value| value.transform_keys!(&:to_sym) }
    create_properties(spaces)
  end

  def owned_properties(player_name)
    properties_owned_by_player = []
    BOARD.each do |board|
      if board.owner == player_name
        properties_owned_by_player << board.name
      end
    end
    puts "Player #{player_name} owns: #{properties_owned_by_player}"
  end

  def roll
    puts "Enter first dice roll"
    num1 = gets.strip.to_i
    puts "Enter second dice roll"
    num2 = gets.strip.to_i
    puts "Dice 1: #{num1}"
    puts "Dice 2: #{num2}"
    total_roll = num1+num2
    puts "Dice roll: #{total_roll}"
    # if num1 == num2 then double set to true
    {dice_roll: total_roll, is_double: num1 == num2 }
  end

  def move_player(player:, move:)
    player.position += move.to_i
    if player.position  > BOARD.length-1
      player.position -= BOARD.length
    end
  end

  def buy_property(player_has, value)
    player_has -= value
  end

  def turn (player)
    puts "#{player.name}, enter exit to stop the game or press enter to start rolling the dice"
    user_input = gets.strip
    exit_text(user_input)
    roll_output = roll
    move_player(player:player, move:roll_output[:dice_roll])
    player_options(player)
    roll_output[:is_double]
  end

  def player_options(player)
    if BOARD[player.position].owner == 'Banker'
      if player.cash >= BOARD[player.position].value
        puts "#{player.name}, you are on #{BOARD[player.position].name} and it's value is #{BOARD[player.position].value} and it is available for buying, you have #{player.cash}, you want to buy this property?"
        user_choice = gets.strip
        if user_choice.downcase == 'yes'
          player.cash = buy_property(player.cash, BOARD[player.position].value)
          BOARD[player.position].owner = player.name
        end
      else
        puts "#{player.name}, you are on #{BOARD[player.position].name} and it's value is #{BOARD[player.position].value} and it is available for buying, but you only have #{player.cash}, and you don't have enough money to buy property"
      end
    else
      puts "#{player.name}, you are on #{BOARD[player.position].name} and it is not available for buying."
    end
  end

  def exit_text(user_input)
    exit if user_input.to_s.strip.downcase == 'exit'
  end
end