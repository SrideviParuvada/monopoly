module Monopoly
  extend self
  require 'yaml'

  def create_board(file = 'Board.yml')
    spaces = YAML.load_file(file)
    spaces.transform_keys!(&:to_sym)
    spaces.each_value { |value| value.transform_keys!(&:to_sym) }
    board = []
    spaces.each do |space|
      board << BoardSpace.new(**space[1])
    end
    board
  end

  BOARD = create_board

  def actions(action:, player:, available_options:)
    return_from_action = nil
    case available_options[action.to_i - 1]
    when 'Buy'
      buy_property(player)
    when 'End Turn'
    when 'End Game'
      exit_text(exit)
    when 'Roll'
      return_from_action = roll
      unless player.in_jail
        move_player(player: player, move: return_from_action[:dice_roll], move_to: nil)
      end
    when 'Pay Rent'
      return_from_action = pay_rent(player)
    else
      puts "Invalid input"
    end
    return_from_action
  end

  def space_index(space_name:)
    BOARD.each_with_index do |space, index|
      if space.name == space_name
        return index
      end
    end
  end

  def jail(player)
    if player.in_jail
      begin
        puts "#{player.name} do you want to pay 50 and resume playing game? enter y/n"
        pay_jail_price = gets.strip.to_s.downcase
        if !(pay_jail_price == 'y' || pay_jail_price == 'n')
          puts "Invalid choice please try again"
        else
          if pay_jail_price == 'y'
            player.cash -= 50
            player.in_jail = false
          end
        end
      end until pay_jail_price == 'y' || pay_jail_price == 'n'
    else
      move_player(player: player, move: nil, move_to: 'Just Visiting')
      player.in_jail = true
      player.has_rolled = true
      player.is_double = false
      player.double_count = 0
    end
  end

  def rail_road_rent(owner)
    count = 0
    BOARD.each do |space|
      if (space.type == 'rail_road' && space.owner == owner)
        count += 1
      end
    end
    rent = count * 25
    puts "#{owner} owns #{count} rail roads so rent is:#{rent}"
    return rent
  end

  def pick_valid_choice(player, options)
    begin
      puts "Please pick one of the options available for you #{player.name}"
      user_input = gets.strip
      if user_input.to_i < 1 || user_input.to_i > options.length + 1
        puts "Invalid choice please try again"
      end
    end until user_input.to_i.between?(1, options.length + 1)
    user_input
  end

  def turn(player)
    begin
      players_current_information(player: player)
      properties_owned_by_player(player.name)
      options = player_options(player)
      user_input = pick_valid_choice(player, options)
      action_out_put = actions(action: user_input, player: player, available_options: options)
      #if output is true or false or nil then it is evident that output is not from roll
      if !(action_out_put.is_a?(TrueClass) || action_out_put.is_a?(FalseClass) || action_out_put.nil?)
        player.is_double = action_out_put[:is_double]
        if (player.in_jail == true && player.is_double)
          #Player come out of jail since he/she rolled double
          player.in_jail = false
        end
        player.double_count += 1 if action_out_put[:is_double]
        player.has_rolled = true
      else
        if !(action_out_put.nil?)
          player.rent_payed = action_out_put
        end
      end
      if player.double_count == 3
        puts "You have rolled doubles 3 times in a row #{player.name}, so you are going to jail"
        jail(player)
      end
    end until (options[user_input.to_i - 1] == 'End Turn') #|| player.double_count == 3)
  end

  def exit_text(user_input)
    exit if user_input.to_s.strip.downcase == 'exit'
  end

end
