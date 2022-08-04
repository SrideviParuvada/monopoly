class BoardSpace
  attr_reader :name, :value, :rent, :type, :color, :mortgage
  attr_accessor :owner, :is_mortgaged
  # **options here takes care of any additional values that are passed, it can be anything and method will ignore it
  def initialize(name:, type:, value: 0, rent: 0, owner: 'Banker', color: nil, mortgage: 0, is_mortgaged: false, **options)
    @name = name
    @type = type
    @value = value
    @rent = rent
    @owner = owner
    @color = color
    @mortgage = mortgage
    @is_mortgaged = is_mortgaged
  end
end

class Player
  attr_reader :name
  attr_accessor :position, :cash, :is_start, :already_in_jail,
                :entered_jail, :in_jail, :jail_roll_count,
                :roll_to_get_out_jail, :status

  def initialize(name:, position: 0, cash: 300, is_start: true, in_jail: false, jail_roll_count: 0, roll_to_get_out_jail: false, status: "Active", **options)
    @name = name
    @position = position
    @cash = cash
    @is_start = is_start
    @in_jail = in_jail
    @jail_roll_count = jail_roll_count
    @status = status
  end

  def player_information
    puts "=================================================================================="
    puts "Player: #{name}\t\tFunds: $#{cash}"
    puts "#{name} owns:  #{owned_properties(name: name)}"
    puts "In jail: #{in_jail}\t\tJail roll count: #{jail_roll_count}"
  end
end

class NewTurn
  attr_reader :player
  attr_accessor :has_rolled, :double_count, :dice_roll, :debt

  def initialize(player:, has_rolled: false, double_count: 0, dice_roll: {}, **args)
    @player = player
    @has_rolled = has_rolled
    @double_count = double_count
    @dice_roll = dice_roll
  end

  def player_turn_information
    log "Has rolled: #{@has_rolled}\tDouble count: #{@double_count}"
    puts "=================================================================================="
    if @player.in_jail
      puts "You are IN JAIL"
    else
      puts "You are on: #{BOARD[@player.position].name}"
      puts "Space value is: #{BOARD[@player.position].value}" unless (BOARD[@player.position].value.nil? || BOARD[@player.position].value == 0)
    end
  end
end

class Card

  attr_reader :name, :action, :additional_information

  def initialize(name:, action:, additional_information:)
    @name = name % [additional_information.to_s]
    @action = action
    @additional_information = additional_information
  end
end

class CardPile
  attr_reader :base_cards, :shuffled_deck

  def initialize(file:)
    @base_cards = populate_file(file: file, class_name: Card)
    assign_cards
  end

  def draw_card
    pick = @shuffled_deck.sample
    @shuffled_deck.delete(pick)
    assign_cards if @shuffled_deck.empty?
    puts "You drew card: #{pick.name}\nYou will #{pick.action} #{pick.additional_information}"
    pick
  end

  def load(file)
    @shuffled_deck = populate_file(file: file, class_name: Card)
  end

  private

  def assign_cards(file: @base_cards)
    @shuffled_deck = file
  end

end