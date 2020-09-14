module Actions
  def roll
    is_double = false
    num1 = rand(1..6)
    num2 = rand(1..6)
    puts "Dice 1: #{num1}"
    puts "Dice 2: #{num2}"
    total_roll = num1+num2
    puts "Dice roll: #{total_roll}"
    is_double = true if num1 == num2
    return total_roll, is_double
  end

  def move (user_position, roll, board_size)
    user_position = user_position + roll
    if user_position >= board_size
      user_position = user_position - board_size
    end
    user_position
  end

  def buy(player_properties, player_cash, player_name, available_properties, property_to_buy, property_value, banker)
    available_properties.delete(property_to_buy)
    player_properties << property_to_buy
    player_cash = player_cash - property_value
    cash = banker.banker_cash
    puts "Im in by and banker cash is: #{cash}"
    cash= cash + property_value
    puts "banker cash: #{cash}"
    banker.property_tracker.store("#{property_to_buy}", "#{player_name}")
    banker.banker_cash<<cash
    return player_properties, available_properties, player_cash,  banker.banker_cash
  end

  def pay_rent(player_cash, current_space_value, banker)
    puts "I'm in pay rent"
    cash = banker.banker_cash
    cash= cash + current_space_value
    banker.banker_cash<<cash
    #@banker_cash = @banker_cash + current_space_value
    player_cash = player_cash - current_space_value
    return player_cash, banker.banker_cash
  end
end


class Property
  attr_reader :name, :value, :owner
  def initialize(name, value, owner)
    @name = name
    @value = value
    @owner = banker
  end
end

class Board
  attr_reader :spaces
  def initialize(banker)
    @spaces = create_board(banker)
  end

  def create_board(banker)
    spaces = []
    properties_hash.each do |name, value|
      spaces << Property.new(name.to_s, value, banker)
    end
    spaces
  end

  def board_length
    spaces.length
  end
  def properties_hash
    {'Mediterranean Avenue': 60,
     'Baltic Avenue': 60,
     'Oriental Avenue': 100,
     'Vermont Avenue': 100,
     'Connecticut Avenue': 120,
     'St.Charles Place': 140,
     'States Avenue': 140,
     'Virginia Avenue': 160,
     'St. James Place': 180,
     #'Tennessee Avenue': 180,
     #'New York Avenue': 200,
     #'Kentucky Avenue': 220,
     #'Indiana Avenue': 220,
     #'Illinois Avenue': 240,
     #'Atlantic Avenue': 260,
     #'Ventnor Avenue': 260,
     #'Marvin Gardens': 280,
     #'Pacific Avenue': 300,
     #'North Carolina Avenue': 300,
     #'Pennsylvania Avenue': 320,
     #'Park Place': 350,
     'Boardwalk': 400}
  end
end

class Banker
  attr_reader :banker_cash, :property_tracker
  def initialize
    @banker_cash = 25000
    @property_tracker = Hash.new
  end
end


class Player
  attr_reader :player_name, :cash, :player_current_position, :player_properties, :is_double, :user_choice
  include Actions

  def initialize(name)
    @player_name = name
    @cash = 1500
    @player_current_position = 0
    @player_properties = Array.new
    @is_double
    @user_choice = nil
  end

  def turn(board, banker, available_properties)
    puts "#{@player_name} is rolling"
    @total_roll, @is_double = roll
    @player_current_position = move(@player_current_position, @total_roll, board.board_length)
    current_space = board.spaces[@player_current_position].name
    current_space_value = board.spaces[@player_current_position].value
    current_space_value = board.spaces[@player_current_position]
    if available_properties.include?(current_space)
      if @cash > current_space_value
        puts "#{@player_name}, you moved to #{current_space}, it is available for buying, it costs #{current_space_value} and you have #{@cash} do you want buy? Yes/No"
        @user_choice = gets.strip.to_s.strip.downcase
        if @user_choice == 'yes'
          @user_choice = 'Buy'
        end
      end
    else
      puts "#{@player_name} you moved to #{current_space} and this property belongs to #{banker.property_tracker["#{current_space}"]}, you need to pay rent, rent is: , you have total cash: #{@cash}"
      @user_choice = 'Pay Rent'
    end

    case @user_choice
    when 'Buy'
      @player_properties, available_properties, @cash, @banker_cash = buy(@player_properties, @cash, @player_name, available_properties, current_space, current_space_value, banker)
      puts "#{@player_name}'s properties #{player_properties} and your available cash is #{@cash}"
      puts "Banker has: #{banker.property_tracker}"
      puts "Banker cash in buy: #{@banker_cash}"
    when 'Pay Rent'
      @cash, @banker_cash  = pay_rent(@cash, current_space_value, banker)
      puts "Banker cash:#{@banker_cash} and players cash: #{@cash}"
    end
    if @is_double == true
      turn(board, banker, available_properties)
    end
    @user_choice
  end
end

puts "How many players would like to play the game?"
number_of_players = gets.strip.to_i
counter = 0
players = []
while counter<number_of_players
  puts "what is player's name?"
  players << Player.new( gets.strip.to_s)
  counter = counter+1
end

banker = Banker.new
board = Board.new(banker)

@available_properties = []
board.spaces.each{|space|
  @available_properties << space.name
}
def exit_text(user_input)
  user_input.to_s.strip.downcase== 'exit'
end

user_input = nil
until exit_text(user_input)
  players.each { |player|
    user_input = player.turn(board, banker, @available_properties)
    break if exit_text(user_input)
  }
end

#each propery class should, object should have a owner field
# Board - Should be an array - probably array of instances for different classes
# When you start the game, we should config file that builds the board
# factory method - builds instances of classes based on configs
# player  should know about players location
# Menus can be different classes
#------home work ----
#research how ruby parses yml file