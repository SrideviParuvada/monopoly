require 'minitest/autorun'
require_relative './classes.rb'
require_relative './modules.rb'

class TestProperty < Minitest::Test
  def setup
    @property = Property.new(name: 'Portland', value: 100 )
  end

  def test_name_read
    assert_equal('Portland', @property.name)
  end

  def test_value_read
    assert_equal(100, @property.value)
  end

  def test_name_write
    assert_raises(NoMethodError) {@property.name = 'New York'}
  end

  def test_value_write
    assert_raises(NoMethodError) {@property.value = 2000}
  end

  def test_name_is_required
    assert_raises(ArgumentError) {Property.new(value: 150)}
  end

  def test_value_is_required
    assert_raises(ArgumentError) {Property.new(name: 'Seattle')}
  end

  def test_default_owner
    assert_equal('Banker', @property.owner)
  end

  def test_change_owner
    @property.owner = "Zames Bond"
    assert_equal('Zames Bond', @property.owner)
  end

end

class TestPlayer < Minitest::Test
  def setup
    @player = Player.new("Guru")
  end

  #instance belong to player class
  def test_class
    assert_equal(Player, @player.class)
  end

  def test_name_read
    assert_equal("Guru", @player.name)
  end

  def test_position_read
    assert_equal(0, @player.position)
  end

  def test_cash_read
    assert_equal(500, @player.cash)
  end

  #Able to assign value to position
  def test_position_write
    @player.position = 10
    assert_equal(10, @player.position)
  end

  #Able to assign value to cash
  def test_cash_write
    @player.cash = 1500
    assert_equal(1500, @player.cash)
  end

  #Not able to change name
  def test_name_write
    assert_raises(NoMethodError) {@player.name = "Tom"}
  end

  #name is required, if not passed, error is thrown
  def test_name_required
    assert_raises(ArgumentError) {Player.new}
  end

end


class TestMonopoly < Minitest::Test
  include Monopoly
  # include yaml

  def setup
    @hash = {:space_03=>{:name=>"Time Square", :type=>"property", :value=>6000}}
    file_body = "space_01:\n\tname: 'Mediterranean Avenue'\n\ttype: property\n\tvalue: 60"
    File.open('test.yml', 'w'){|file|file.puts file_body}
    @name = 'Bob'
  end

  def test_create_properties
    actual = create_properties(@hash)
    assert_equal(false, actual.nil?)
    assert_equal(1, actual.length)
    assert_equal(Array, actual.class)
    assert_equal(Property, actual.first.class)
  end

  def test_create_properties_no_hash
    test = 'Not a hash'
    assert_raises(NoMethodError) {create_properties(test)}
  end

  def test_create_properties_single_hash
    test = {:key =>'Not a hash'}
    assert_raises(TypeError) {create_properties(test)}
  end

  #-------all new added -------
  # yml is not recognised by minitest so couldn't write tests for create_board
  # def test_create_board
  #   actual = create_board('test.yml')
  #   assert_equal(false, actual.nil?)
  #   assert_equal(1, actual.length)
  #   assert_equal(Array, actual.class)
  #   assert_equal(Property, actual.first.class)
  # end
  #Notable to do this test either
  def test_owned_properties
    BOARD.first.owner = @name
    actual = owned_properties(@name)
    assert_equal(Array, actual.class)
    assert_equal(false, actual.empty?)
    assert_equal(1, actual.length)
  end

  def test_roll
    actual = roll(min:10, max:20)
    assert_equal(Hash, actual.class)
    assert_equal(Integer, actual[:dice_roll].class)
    assert_includes([TrueClass, FalseClass], actual[:is_double].class)
    assert_includes([true, false], actual[:is_double])
    assert_operator(actual[:dice_roll], :<=, 40)
    assert_operator(actual[:dice_roll], :>=, 20)
  end

  def test_roll_double
    actual = roll(min:10, max:10)
    assert_equal(true, actual[:is_double])
  end

    #Even this one needs BOARD
  # def test_move_player
  #   test_player = Player.new("Sridevi")
  #   actual = move_player(player:test_player, move:25)
  #   assert_equal(test_player.position, 21)
  # end
    #
  # def test_buy_property
  #   assert_equal(8, buy_property(15, 7))
  #   assert_equal(0, buy_property(7, 7))
  # end

  def test_turn
    # this one takes user input ...not sure how to test that in a unit test, may be we need to change the method
  end

  def test_player_options
    # this one needs BOARD
  end

  def test_exit_text
    #This one needs user inout
  end
end

# Write tests for all the classes and nice to have write a test for module all modules -- look at ent toend test params
