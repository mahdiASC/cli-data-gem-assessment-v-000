class Pokemon
  attr_accessor :name, :type1, :type2, :hp, :att, :def, :spAtt, :spDef, :spd, :moves

  def initialize(arr)
    @name, @type1, @type2, @hp, @att, @def, @spAtt, @spDef, @spd = arr
    @moves = []
  end

  def alive?
    @hp > 0
  end

  def attacks(oppPokemon, move)
    #simplified dmg calculations
    oppPokemon.hp -= @att
  end

  def canAttack?
    #returns true if pokemon has enough PP to attack
    @moves.any?{|move| move.usable?}
  end

  def usableMoves
    #returns array of usable moves
    @moves.select{|move| move.usable?}
  end
end
