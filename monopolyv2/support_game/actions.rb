def turn(current_turn:)
  player = current_turn.player
  player.player_information
  current_turn.player_turn_information
  option = player_options(current_turn)
  puts "option returned: #{option}"
  return if option == 'end_turn'
  send option, current_turn: current_turn
  return if option == 'forfeit'
  turn(current_turn: current_turn)
end

def roll(current_turn:)
  player = current_turn.player
  player.is_start = false
  current_turn.dice_roll = roll_dice
  current_turn.has_rolled = true
  if player.in_jail
    check_for_release(current_turn: current_turn)
  else
    check_for_double(current_turn: current_turn) if current_turn.dice_roll[:is_double]
  end
  roll_result(current_turn: current_turn)
end

def roll_result(current_turn:)
  player = current_turn.player
  move_player(current_turn: current_turn) unless player.in_jail
  go_to_jail(current_turn: current_turn) if BOARD[player.position].name == 'GO TO JAIL'
  handle_cards(current_turn: current_turn)
  calculate_and_pay_debt(current_turn: current_turn)
end

def handle_cards(current_turn:)
  player = current_turn.player
  if BOARD[player.position].name == 'Community Chest'
    community_chest_card = @community_chest.draw_card
    send community_chest_card.action, current_turn: current_turn, additional_info: community_chest_card.additional_information
  elsif BOARD[player.position].name == 'Chance'
    chance_card = @chance_cards.draw_card if BOARD[player.position].name == 'Chance'
    send chance_card.action, current_turn: current_turn, additional_info: chance_card.additional_information
  end
end

def return_player(owner:)
  @players.each do |player|
    return player if player.name == owner
  end
end

def buy(current_turn:)
  player = current_turn.player
  player.cash -= BOARD[player.position].value
  BOARD[player.position].owner = player.name
end

def post_bail(current_turn:)
  player = current_turn.player
  player.in_jail = false
  player.jail_roll_count = 0
  player.cash -= 50
  puts "#{player.name} you are out of jail"
end

def debug_roll(current_turn:)
  puts "Enter dice roll 1"
  $debug_num1 = enter_correct_roll
  puts "Enter dice roll 2"
  $debug_num2 = enter_correct_roll
  roll(current_turn: current_turn)
end

def forfeit(current_turn:)
  player = current_turn.player
  player.cash = 0
  BOARD.each { |space|
    if space.owner == player.name
      space.owner = 'Banker'
    end
  }
  player.status = "Inactive"
end

def enter_correct_roll
  begin
    user_input = gets&.strip.to_i
    if user_input < 1 || user_input > 6
      puts "invalid input : dice roll should be between 1 and 6 please enter again"
    end
  end until user_input.between?(1, 6)
  user_input
end

def debug_teleport_player(current_turn:)
  player = current_turn.player
  puts "#{player.name} please enter space you want to teleport to"
  begin
    space_name = gets&.strip.to_s
    result = BOARD.find { |space| space.name.downcase == space_name.downcase }
    if result.nil?
      puts "'#{space_name}' doesn't exist on the board, please enter valid name"
    end
  end until result
  move_to(current_turn: current_turn, space: space_name)
end