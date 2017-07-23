class Pokemon
  attr_accessor :name, :type1, :type2, :hp, :att, :def, :spAtt, :spDef, :spd, :moves


  def initialize(arr, flag=false)
    #flag is for enemy to have perfect stats
    @name, @type1, @type2, @hp, @att, @def, @spAtt, @spDef, @spd = arr

    #Determine proper stats
    #https://www.dragonflycave.com/mechanics/stats
    #Individual stats (0-15)
    atkIV = flag ? 15: rand(15)
    @att += atkIV
    @att = @att*2+68
    

    defIV = flag ? 15:rand(15)
    @def += defIV
    @def = @def*2+68

    spdIV = flag ? 15:rand(15)
    @spd += spdIV
    @spd = @spd*2+68

    spIV = flag ? 15:rand(15)
    @spAtt += spIV
    @spAtt = @spAtt*2+68
    @spDef += spIV
    @spDef = @spDef*2+68

    #how HP and IV are connected
    if atkIV%2==1
      @hp +=  8
    end
    
    if defIV%2==1
      @hp +=  4
    end
    
    if spdIV%2==1
      @hp +=  2
    end
    
    if spIV%2==1
      @hp +=  1
    end
    @hp = @hp*2+110

    @moves = []
  end

  def alive?
    @hp > 0
  end

  def attacks(oppPokemon, move)
    #dmg calculations
    
    attackStat = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost"].include?(move.type) ? @att : @spAtt
    attackPower = move.dmg
    defenseStat = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost"].include?(move.type) ? oppPokemon.def : oppPokemon.spDef
    randNum = rand(255-217)+217
    stab = move.type == @type1 || move.type == @type2 ? 1.5 : 1
    weakResist = calcWeakResist(oppPokemon,move)
    #OMIT#
    # puts "attackStat: #{attackStat}"
    # puts "attackPower: #{attackPower}"
    # puts "defenseStat: #{defenseStat}"
    # puts "randNum: #{randNum}"
    # puts "stab: #{stab}"
    # puts "weakResist: #{weakResist}"
    damageTotal = (((((42 * attackStat.to_f * (attackPower.to_f/defenseStat.to_f))/50)+2)*stab.to_f*weakResist.to_f)*randNum.to_f/255).floor

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
    type = (typeInput || oppPokemon.type1).downcase
    output = 1; #number returned as modifier
    case move.type.downcase
    when 'normal'
      if ['ghost'].include?(type)
        output *= 0
      end
    when 'bug'
      if ['fire','flying',"rock"].include?(type)
        output*=0.5
      elsif ['grass','poison',"psychic"].include?(type)
        output*=2
      end
    when 'dragon'
      #No effectiveness
    when 'ice'
      if ['ice','water'].include?(type)
        output*=0.5
      elsif ['dragon','flying','grass','ground'].include?(type)
        output*=2
      end
    when 'fighting'
      if ['flying','psychic'].include?(type)
        output*=0.5
      elsif ['ice','normal','rock'].include?(type)
        output*=2
      elsif ['ghost'].include?(type)
        output*=0
      end
    when 'fire'
      if ['rock','water'].include?(type)
        output*=0.5
      elsif ['bug','grass','ice'].include?(type)
        output*=2
      end
    when 'flying'
      if ['electric','rock'].include?(type)
        output*=0.5
      elsif ['bug','fighting',"grass"].include?(type)
        output*=2
      end
    when 'grass'
      if ['bug','fire','flying','grass','poison'].include?(type)
        output*=0.5
      elsif ['ground','rock','water'].include?(type)
        output*=2
      end
    when 'ghost'
      if ['normal','psychic'].include?(type)
        output*=0
      end
    when 'ground'
      if ['grass'].include?(type)
        output*=0.5
      elsif ['electric','fire','poison','rock'].include?(type)
        output*=2
      elsif ['flying'].include?(type)
        output*=0
      end
    when 'electric'
      if ['electric','grass'].include?(type)
        output*=0.5
      elsif ['flying','water'].include?(type)
        output*=2
      elsif ['ground'].include?(type)
        output*=0
      end
    when 'poison'
      if ['ground','poison','rock'].include?(type)
        output*=0.5
      elsif ['bug','grass'].include?(type)
        output*=2
      end
    when 'psychic'
      if ['psychic'].include?(type)
        output*=0.5
      elsif ['fighting','poison'].include?(type)
        output*=2
      end
    when 'rock'
      if ['fighting','rock'].include?(type)
      elsif ['bug','fire','flying','ice'].include?(type)
      end
    when 'water'
      if ['grass','ice'].include?(type)
        output*=0.5
      elsif ['fire','ground','rock'].include?(type)
        output*=2
      end
    else
      puts "SOMETHING WENT WRONG WITH TYPE DMG"
      puts "MoveType: #{move.type.downcase} Type: #{type.downcase}"
    end
    


    if(typeInput.nil? && oppPokemon.type2 !="")
      output *= calcWeakResist(oppPokemon,move, oppPokemon.type2)
    end
    #OMIT#
    # if output ==0
    #   puts "WARNING, OUTPUT IS 0!"
    # end
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
