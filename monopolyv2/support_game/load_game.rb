def populate_file(file:, class_name:)
  file_contents = transform_file_contents(file: file)
  result = []
  file_contents.each do |content|
    result << class_name.new(**content[1])
  end
  result
end

def populate_players(file:)
  players = transform_file_contents(file: file)
  @players = []
  players.each do |player|
    @players << Player.new(**player[1])
  end
end

def populate_turn(file:)
  turn = YAML.load_file(file)
  turn.transform_keys!(&:to_sym)
  turn[:player] = @players.find { |player| player.name == turn[:player] }
  turn[:dice_roll] = { total: turn[:total], is_double: turn[:is_double] }
  @current_turn = NewTurn.new(**turn)
  re_order_players
end

def re_order_players
  index = @players.find_index(@current_turn.player)
  @players.rotate!(index)
end

def load_game
  log 'load_game'
  populate_players(file: 'save_players.yml')
  populate_turn(file: 'save_current_turn.yml')
  @community_chest.load('save_community_chest.yml')
  @chance_cards.load('save_chance_cards.yml')
  populate_file(file: 'save_board.yml', class_name: BoardSpace)
end