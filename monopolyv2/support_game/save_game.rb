require 'yaml'

def save(data:, type:, file_name:)
  main_hash = {}
  data.each_with_index do |object, index|
    key = "#{type}_#{index}"
    sub_hash = {}
    object.instance_variables.each do |variable|
      #variable.to_s[1..-1] this will chop off the first character, in this case '@'
      hash_key = variable.to_s[1..-1]
      sub_hash[hash_key] = object.send(hash_key)
    end
    main_hash[key] = sub_hash
  end
  File.open(file_name, 'w') { |file| file.write(main_hash.to_yaml) }
end

def save_current_turn(current_turn:)
  main_hash = {}
  main_hash['player'] = current_turn.player.name
  current_turn.instance_variables.each do |variable|
    #variable.to_s[1..-1] this will chop off the first character, in this case '@'
    hash_key = variable.to_s[1..-1]
    if hash_key == 'dice_roll'
      dice_roll = current_turn.send(hash_key)
      dice_roll.each { |key, value| main_hash[key] = value }
    elsif hash_key != 'player'
      main_hash[hash_key] = current_turn.send(hash_key)
    end

  end
  File.open('save_current_turn.yml', 'w') { |file| file.write(main_hash.to_yaml) }
end


def save_game(current_turn: current_turn)
  save(data: BOARD, type: 'space', file_name: 'save_board.yml')
  save(data: @players, type: 'player', file_name: 'save_players.yml')
  save_current_turn(current_turn: current_turn)
end
