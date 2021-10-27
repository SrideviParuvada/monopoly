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
  name = ''
  number_of_players.times do |count|
    puts "What is the name of the player #{count + 1}?"
    begin
      name = gets.strip.to_s
      if names.include? name
        puts "Please enter different name as there is another player with name, '#{name}' already in the game"
        name = ''
      else
        names << name
        @players << Player.new(name: name)
      end
    end until (name != '')
  end

  #Create new board
  populate_board(file: 'Board.yml')
end

