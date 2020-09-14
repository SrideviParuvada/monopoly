class Property
  attr_reader :name, :value
  attr_accessor :owner
  # **options here takes care of any additional values other than name and value are passed, it can be anything but method will ignore it
  def initialize(name:, value:, **options)
    @name = name
    @value = value
    @owner = 'Banker'
  end
end

class Player
  attr_reader :name
  attr_accessor :position, :cash
  def initialize(name)
    @name = name
    @position = 0
    @cash = 500
  end
end


