def exit_game
  exit
end

def load_file(file:)
  file_contents = YAML.load_file(file)
  file_contents.transform_keys!(&:to_sym)
  file_contents.each_value do |value|
    value.transform_keys!(&:to_sym)
  end
  file_contents
end

def owned_properties(name:)
  player_properties = []
  BOARD.each do |space|
    player_properties << space.name if space.owner.eql? name
  end
  player_properties
end

def turn(current_turn)
  player = current_turn.player
  player.player_information
  #HW 9/29 Finish this method
  # Current_debt should be displayed under player info
  current_turn.player_turn_information
  option = player_options(current_turn)
  if option == 'end_turn'
    return
  end

  actions(action: option, current_turn: current_turn)
  turn(current_turn)
end

