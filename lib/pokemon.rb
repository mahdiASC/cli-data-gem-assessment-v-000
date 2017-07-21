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
    
    attackStat = ["Normal", "Fighting", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost"].include?(move.type) ? @att : @spAtt
    attackPower = move.dmg
    defenseStat = ["Normal", "Fighting", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost"].include?(move.type) ? oppPokemon.def : oppPokemon.spDef
    randNum = rand(15)+85
    stab = move.type == @type1 || move.type == @type2 ? 1.5 : 1
    weakResist = calcWeakResist(oppPokemon,move)
    #OMIT#
    # puts "attackStat: #{attackStat}"
    # puts "attackPower: #{attackPower}"
    # puts "defenseStat: #{defenseStat}"
    # puts "randNum: #{randNum}"
    # puts "stab: #{stab}"
    # puts "weakResist: #{weakResist}"
    damageTotal = ((((42 * attackStat.to_f * (attackPower.to_f/defenseStat.to_f))/50)+2)*stab.to_f*weakResist.to_f*randNum.to_f/100).floor

    # Damage applied
    move.pp -= 1
    oppPokemon.hp -= damageTotal
    if oppPokemon.hp < 0
      oppPokemon.hp = 0 #just in case HP checked
    end
    [damageTotal,weakResist]
  end

  def calcWeakResist(oppPokemon,move, typeInput=nil)
    #returns multiplier for attack effectiveness
    #0.25, 0.5, 1, 2, or 4
    # http://unrealitymag.com/wp-content/uploads/2014/11/rby-rules.jpg
    type = typeInput || oppPokemon.type1
    puts type
    output = 1; #number returned as modifier
    case move.type
    when 'Normal'
      if ['Ghost'].include?(type)
        output *= 0
      end
    when 'Bug'
      if ['Fire','Flying',"Rock"].include?(type)
        output*=0.5
      elsif ['Grass','Poison',"Psychic"].include?(type)
        output*=2
      end
    when 'Dragon'
      #No effectiveness
    when 'Ice'
      if ['Ice','Water'].include?(type)
        output*=0.5
      elsif ['Dragon','Flying','Grass','Ground'].include?(type)
        output*=2
      end
    when 'Fighting'
      if ['Flying','Psychic'].include?(type)
        output*=0.5
      elsif ['Ice','Normal','Rock'].include?(type)
        output*=2
      elsif ['Ghost'].include?(type)
        output*=0
      end
    when 'Fire'
      if ['Rock','Water'].include?(type)
        output*=0.5
      elsif ['Bug','Grass','Ice'].include?(type)
        output*=2
      end
    when 'Flying'
      if ['Electric','Rock'].include?(type)
        output*=0.5
      elsif ['Bug','Fighting',"Grass"].include?(type)
        output*=2
      end
    when 'Grass'
      if ['Bug','Fire','Flying','Grass','Poison'].include?(type)
        output*=0.5
      elsif ['Ground','Rock','Water'].include?(type)
        output*=2
      end
    when 'Ghost'
      if ['Normal','Psychic'].include?(type)
        output*=0
      end
    when 'Ground'
      if ['Grass'].include?(type)
        output*=0.5
      elsif ['Electric','Fire','Poison','Rock'].include?(type)
        output*=2
      elsif ['Flying'].include?(type)
        output*=0
      end
    when 'Electric'
      if ['Electric','Grass'].include?(type)
        output*=0.5
      elsif ['Flying','Water'].include?(type)
        output*=2
      elsif ['Ground'].include?(type)
        output*=0
      end
    when 'Poison'
      if ['Ground','Poison','Rock'].include?(type)
        output*=0.5
      elsif ['Bug','Grass'].include?(type)
        output*=2
      end
    when 'Psychic'
      if ['Psychic'].include?(type)
        output*=0.5
      elsif ['Fighting','Poison'].include?(type)
        output*=2
      end
    when 'Rock'
      if ['Fighting','Rock'].include?(type)
      elsif ['Bug','Fire','Flying','Ice'].include?(type)
      end
    when 'Water'
      if ['Grass','Ice'].include?(type)
        output*=0.5
      elsif ['Fire','Ground','Rock'].include?(type)
        output*=2
      end
    else
      puts "SOMETHING WENT WRONG WITH TYPE DMG"
      puts "Move: #{move} Type: #{type}"
    end
    


    if(typeInput.nil? && oppPokemon.type2 !="")
      output *= calcWeakResist(oppPokemon,move, oppPokemon.type2)
    end
    #OMIT#
    if output ==0
      puts "WARNING, OUTPUT IS 0!"
    end
    output
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
