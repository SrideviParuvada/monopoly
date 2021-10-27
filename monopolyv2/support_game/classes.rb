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
                :roll_to_get_out_jail

  def initialize(name:, position: 0, cash: 1500, is_start: true, in_jail: false, jail_roll_count: 0, roll_to_get_out_jail: false, **options)
    @name = name
    @position = position
    @cash = cash
    @is_start = is_start
    @in_jail = in_jail
    @jail_roll_count = jail_roll_count
    @roll_to_get_out_jail = roll_to_get_out_jail
  end

  def player_information
    puts "Player: #{name}\t\tFunds: $#{cash}"
    puts "Owned properties:  #{owned_properties(name: name)}"
  end
end

class NewTurn
  attr_reader :player
  attr_accessor :has_rolled, :double_count, :dice_roll, :debt

  def initialize(player:, has_rolled: false, double_count: 0, dice_roll: {}, debt: 0, **args)
    @player = player
    @has_rolled = has_rolled
    @double_count = double_count
    @dice_roll = dice_roll
    @debt = debt
  end

  def player_turn_information
    log "Has rolled: #{@has_rolled}\t\tDouble count: #{@double_count}"
    puts "You are on: #{BOARD[@player.position].name}"
  end
end