class BoardSpace
  attr_reader :name, :value, :rent, :type
  attr_accessor :owner
  # **options here takes care of any additional values other than name and value are passed, it can be anything but method will ignore it
  def initialize(name:, type:, value:'', rent:'', **options)
    @name = name
    @type = type
    @value = value
    @rent = rent
    @owner = 'Banker'
  end
end

class Player
  attr_reader :name
  attr_accessor :position, :cash, :is_start, :in_jail, :has_rolled, :double_count, :is_double, :rent_payed
  def initialize(name)
    @name = name
    @position = 0
    @cash = 1500
    @is_start = true
    @in_jail = false
    @has_rolled = false
    @double_count = 0
    @is_double = false
    @rent_payed = false
  end
end


