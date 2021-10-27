def populate_board(file:)
  spaces = load_file(file: file)
  board = []
  spaces.each do |space|
    board << BoardSpace.new(**space[1])
  end
  board
end

def populate_players(file:)
  players = load_file(file: file)
  @players = []
  players.each do |player|
    @players << Player.new(**player[1])
  end
end

def populate_turn(file:)
  turn = YAML.load_file(file)
  turn.transform_keys!(&:to_sym)
  turn[:player] = @players.find { |player| player.name == turn[:player] }
  turn[:dice_roll] = {total: turn[:total], is_double: turn[:is_double]}
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
  populate_board(file: 'save_board.yml')
end