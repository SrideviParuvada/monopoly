def new_game
  #Instantiate players
  begin
    puts 'How many players would like to play the game?'
    number_of_players = gets.strip.to_i
    if number_of_players < 1 || number_of_players > 4
      puts 'Invalid choice'
    end
  end until number_of_players.between?(1, 4)

  @players = []
  names = []
  number_of_players.times do |count|
    puts "What is the name of the player #{count + 1}?"
    begin
      name = gets.strip.to_s
      if names.include? name
        puts "Please enter different name as there is another player with name, '#{name}' already in the game"
        name = false
      else
        names << name
        @players << Player.new(name: name)
      end
      end until name != false
  end
  #Initiate new community chest and chance cards piles
  # @community_chest = CardPile.new(file: 'Community_chest.yml')
  # @chance_cards = CardPile.new(file: 'Chance_cards.yml')
  # community = CardPile.new
  #
  #  @community_chest = community.load_file(file: 'Community_chest.yml')
  #  @chance_cards = community.load_file(file: 'Chance_cards.yml')
  #Create new board
  populate_file(file: 'Board.yml', class_name: BoardSpace)
end

