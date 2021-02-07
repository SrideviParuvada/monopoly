def players_current_information(player)
  #Below command should clear the board before displaying next puts statement but it is not working as anticipated
  system 'clear'
  puts "\nCurrent player:\t\t#{player.name}"
  puts "Has:\t\t\t$#{player.cash}"
  puts "Is on:\t\t\t#{BOARD[player.position].name}"
  if BOARD[player.position].type != 'space'
    puts "It's value is:\t\t#{BOARD[player.position].value}"
    puts "It's rent is:\t\t#{BOARD[player.position].rent}"
    puts "This property owned by:\t#{BOARD[player.position].owner}"
  end
end

def player_information(player_name)
  @players.each do |player|
    if player.name == player_name
      return player
    end
  end
end

def check_player_funds(player)
  if player.cash <= 0
    if properties_owned_by_player(player.name).length > 0
      log "player have some properties"
    else
      log "player doesn't have enough funds continue play"
      @players = @players.delete player
    end
  end
end

def properties_owned_by_player(player_name)
  properties_owned_by_player = []
  BOARD.each do |board|
    unless board.owner.nil?
      if board.owner == player_name
        properties_owned_by_player << board.name
      end
    end
  end
  puts "Player #{player_name} owns: #{properties_owned_by_player}"
  properties_owned_by_player
end

def player_options(player)
  property_value = BOARD[player.position].value
  owner = BOARD[player.position].owner
  space_type = BOARD[player.position].type
  i_need_pay_rent = false
  property_owned_by_other_player = true if (owner != 'Banker' && owner != player.name && owner != 'nil')
  options = []
  if (space_type == 'property' || space_type == 'rail_road')
    options << 'Buy' if (owner == 'Banker' && player.cash >= property_value && player.has_rolled)
    if (property_owned_by_other_player && player.rent_payed == false)
      options << 'Pay Rent'
      i_need_pay_rent = true
    end
  end
  options << 'Roll' if ((player.has_rolled == false || player.is_double) && i_need_pay_rent == false)
  options << 'End Turn' if (player.has_rolled && (!player.is_double || player.in_jail) && (owner == 'Banker' || owner == player.name || player.rent_payed == true))
  options << 'End Game'
  puts "#{player.name}, you have following options to chose from"
  options.each_with_index do |value, index|
    puts "#{index + 1}:#{value}"
  end
  options
end
