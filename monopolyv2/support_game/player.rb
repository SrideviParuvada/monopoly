def player_options(current_turn)
  options = []
  player = current_turn.player
  property_value = BOARD[player.position].value
  owner = BOARD[player.position].owner
  is_mortgaged = BOARD[player.position].is_mortgaged
  #puts "Debt:#{current_turn.debt}, has rolled: #{current_turn.has_rolled}, in jail: #{player.in_jail}" if DEBUG
  puts "Debt:#{current_turn.debt}"
  options << 'Pay Debt' if current_turn.debt.to_i > 0 && (!player.in_jail)
  options << 'Roll' unless current_turn.has_rolled || player.jail_roll_count >= 3 || (current_turn.debt.to_i > 0 && !player.in_jail)
  options << 'Buy' if owner == 'Banker' && property_value > 0 && player.cash >= property_value && !is_mortgaged
  options << 'End Turn' unless options.include?('Roll') || options.include?('Pay Debt')
  options << 'Manage Properties' if options.include?('Roll')
  options << 'End Game'
  options << 'Save Game'
  options << 'DEBUG:dice_roll' if DEBUG == 'true' && options.include?('Roll')
  menu(options: options,
       title: 'please choose one of the options', name: player.name)
  #puts "#{player.name}, you have following options to choose from"
  #options.each_with_index { |value, index| puts "#{index + 1}:#{value}" }
  #options
end
