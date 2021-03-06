require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < Minitest::Test
  def setup
    @cell1 = Cell.new("B4")
    @cell2 = Cell.new("C3")
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Cell, @cell1
  end

  def test_has_readable_attributes
    assert_equal "B4", @cell1.coordinate
  end

  def test_ship_is_nil_by_default
    assert_nil @cell1.ship
  end

  def test_cell_is_empty_by_default
    assert_equal true, @cell1.empty?
  end

  def test_place_ship_adds_to_ship_method
    @cell1.place_ship(@cruiser)
    assert_equal @cruiser, @cell1.ship
  end

  def test_place_ship_makes_cell_not_empty
    @cell1.place_ship(@cruiser)
    assert_equal false, @cell1.empty?
  end

  def test_fired_upon_is_false_by_default
    assert_equal false, @cell1.fired_upon?
  end

  def test_if_firing_on_ship_lowers_health
    @cell1.place_ship(@cruiser)
    @cell1.fire_upon
    assert_equal 2, @cell1.ship.health
  end

  def test_firing_on_ship_changes_fired_upon_boolean
    @cell1.place_ship(@cruiser)
    assert_equal false, @cell1.fired_upon?
    @cell1.fire_upon
    assert_equal true, @cell1.fired_upon?
  end

  def test_cell_value_is_period_by_default
    assert_equal ".", @cell1.render
  end

  def test_cell_value_is_M_when_fired_upon_and_no_ship_present
    @cell1.fire_upon
    assert_equal "M", @cell1.render
  end

  def test_cell_value_is_period_with_ship_and_no_argument
    @cell2.place_ship(@cruiser)
    assert_equal ".", @cell2.render
  end

  def test_cell_value_is_S_with_ship_and_argument
    @cell2.place_ship(@cruiser)
    assert_equal "S", @cell2.render(true)
    assert_equal ".", @cell2.render(false)
  end

  def test_cell_value_is_H_with_ship_and_fired_upon
    @cell2.place_ship(@cruiser)
    @cell2.fire_upon
    assert_equal "H", @cell2.render
  end

  def test_if_ship_is_sunk_cell_value_is_X
    @cell2.place_ship(@cruiser)
    @cell2.fire_upon
    @cruiser.hit
    @cruiser.hit
    assert_equal true, @cruiser.sunk?
    assert_equal "X", @cell2.render
  end
end
