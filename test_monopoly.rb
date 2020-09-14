require 'minitest/autorun'
require_relative './classes.rb'
require_relative './modules.rb'

class TestProperty < Minitest::Test
  def setup
    @property = Property.new(name: 'Portland', value: 100 )
  end

  def test_required_name
    assert_equal('Portland', @property.name)
  end

end

class TestMonopoly < Minitest::Test
  include Monopoly

  def test_create_properties
    create_properties(space_01:
                          name: 'Mediterranean Avenue'
                          type: property
                          value: 60)
  end

end

# Write tests for all the classes and nice to have write a test for module all modules -- look at ent toend test params
#