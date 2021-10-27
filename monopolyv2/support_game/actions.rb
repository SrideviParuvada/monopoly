def roll_dice(min: 1, max: 6)
  num1 = $debug_num1 || rand(min..max)
  num2 = $debug_num2 || rand(min..max)
  puts "Dice roll result: #{num1} and #{num2}"
  $debug_num1 = nil
  $debug_num2 = nil
  { total: num1 + num2, is_double: num1 == num2 }
end

def move_player(current_turn:)
  player = current_turn.player
  length = BOARD.length
  log "player position before moving: #{player.position}"
  total = current_turn.dice_roll[:total]
  player.position = player.position + total
  if player.position > length-1
    player.position = player.position - length -1
  end
  log "player position after moving: #{player.position}"
end

def is_owned_by_other_player(current_turn:)
  type = BOARD[current_turn.player.position].type
  owner = BOARD[current_turn.player.position].owner
  rent = BOARD[current_turn.player.position].rent
  #binding.pry
  player_name = current_turn.player.name
  return rent if ['property', 'rail_road', 'utility'].include?(type) && (owner != player_name && owner != 'Banker')
end

def roll_and_move(current_turn)
  player = current_turn.player
  current_turn.dice_roll = roll_dice
  current_turn.has_rolled = true
  if player.in_jail
    if current_turn.dice_roll[:is_double]
      current_turn.debt -= 50
      player.in_jail = false
      puts "#{player.name} you are out of jail"
    else
      player.jail_roll_count += 1
      puts "#{player.name} since you didn't roll double and you cannot get out of jail, you have #{3 - player.jail_roll_count} more chance(s) left."
      return
    end
  else
    if current_turn.dice_roll[:is_double]
      current_turn.double_count += 1
      if current_turn.double_count == 3
        go_to_jail(current_turn: current_turn)
        return
      end
      current_turn.has_rolled = false
    end
  end
  move_player(current_turn: current_turn)
  rent = is_owned_by_other_player(current_turn: current_turn)
  current_turn.debt = rent if rent !=nil
end

def return_player(owner)
  @players.each do |player|
    return player if player.name == owner
  end
end

def buy_property(player)
  player.cash -= BOARD[player.position].value
  BOARD[player.position].owner = player.name
end

def pay_debt(current_turn:)
  player = current_turn.player
  if player.cash < current_turn.debt
    puts "#{player.name}, you don't have enough cash to pay rent, we need to either borrow money or sell properties"
  else
    player.cash -= current_turn.debt
    current_turn.debt = 0
    if player.in_jail
      puts "You are out of jail"
      player.in_jail = false
      player.jail_roll_count = 0
      current_turn.has_rolled = false
    else
      owner = BOARD[player.position].owner
      if owner != 'Banker'
        owner_player = return_player(owner)
        owner_player.cash += current_turn.debt
      end
    end
  end
end

def actions(action:, current_turn:)
  player = current_turn.player
  case action
  when 'Manage Properties'
    sub_menu = manage_properties_menu(player: player)
    user_input = pick_valid_choice(options: sub_menu)
    property_actions(input: user_input, player: player)
  when 'buy'
    buy_property(player)
  when 'end_turn'
    nil
  when 'end_game'
    exit_game
  when 'roll'
    roll_and_move(current_turn)
  when 'pay_debt'
    pay_debt(current_turn: current_turn)
  when 'save_game'
    save_game(current_turn: current_turn)
  when 'DEBUG:dice_roll'
    puts "Enter dice roll 1"
    $debug_num1 = gets.strip.to_i
    puts "Enter dice roll 2"
    $debug_num2 = gets.strip.to_i
  else
    puts 'Invalid input'
  end
end