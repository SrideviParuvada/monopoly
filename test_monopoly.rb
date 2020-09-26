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


# class TestMonopoly < Minitest::Test
#   include Monopoly
#
#   def setup
#     player = Player.new
#   end
#
#   def test_create_properties
#     create_properties(space_01:
#                           name: 'Mediterranean Avenue'
#                           type: property
#                           value: 60)
#   end
#
#   def test_move_player(player, 23)
#     assert_equal(1, player.position)
#   end
#
#
# end

# Write tests for all the classes and nice to have write a test for module all modules -- look at ent toend test params
#