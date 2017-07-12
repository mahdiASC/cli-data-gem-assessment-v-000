# Damage Calculation
# https://bulbapedia.bulbagarden.net/wiki/Damage

#making generic moves
class Move
  attr_accessor :name, :dmg, :type, :pp

  def initialize (name, dmg, type, pp)
    @name = name
    @dmg = dmg
    @type = type
    @pp = pp
  end
end

def randSpecialMove(size)

end 

#Creates a hash of all 4 moves for a Pokemon Object
def createMoveset
end
