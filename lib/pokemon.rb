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
    #dmg calculations
    attackStat = move.type == "Normal" ? @att : @spAtt
    attackPower = move.dmg
    defenseStat = move.type == "Normal" ? oppPokemon.def : oppPokemon.spDef
    randNum = rand(15)+85
    stab = move.type == @type1 || move.type == @type2 ? 1.5 : 1
    weakResist = calcWeakResist(oppPokemon,move)

    damageTotal = ((((42 * attackStat * (attackPower/defenseStat))/50)+2)*stab*weakResist*randNum/100).ceil

    # Damage applied
    move.pp -= 1
    oppPokemon.hp -= damageTotal
    if oppPokemon.hp < 0
      oppPokemon.hp = 0 #just in case HP checked
    end
    damageTotal
  end

  def calcWeakResist(oppPokemon,move)
    #returns multiplier for attack effectiveness
    #0.25, 0.5, 1, 2, or 4
    # http://imgur.com/DLuksLi

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
