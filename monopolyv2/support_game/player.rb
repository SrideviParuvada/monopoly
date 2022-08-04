
def player_options(current_turn)
  options = []
  player = current_turn.player
  property_value = BOARD[player.position].value
  owner = BOARD[player.position].owner
  is_mortgaged = BOARD[player.position].is_mortgaged
  options << 'Post Bail' if player.in_jail
  options << 'Roll' unless current_turn.has_rolled || player.cash < 0
  options << 'Buy' if owner == 'Banker' && property_value > 0 && player.cash >= property_value
  options << 'End Turn' if (current_turn.has_rolled && player.cash >= 0)
  options << 'Manage Properties' if owned_properties(name: player.name).length> 0
  options << 'End Game'
  options << 'Save Game'
  options << 'Forfeit'
  options << 'DEBUG Roll' if DEBUG == 'true' && options.include?('Roll')
  # options << 'DEBUG Teleport Player' if DEBUG == 'true' && options.include?('Roll')
  puts "#{player.name}, your funds are negative, unfortunately you cannot play game further" if options.length == 2 && options.include?('End Game')
  menu(options: options,
       title: 'please choose one of these options', name: player.name)
end
