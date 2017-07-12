# Damage Calculation
# https://bulbapedia.bulbagarden.net/wiki/Damage

#making generic moves
class Move
  attr_accessor :name, :dmg, :type

  def initialize (name, dmg, type)
    @name = name
    @dmg = dmg
    @type = type
  end
end
