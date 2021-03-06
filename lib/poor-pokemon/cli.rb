class PoorPokemon::CLI
  attr_accessor :player, :enemy, :pokedex, :difficulty

  def initialize
    @player = PoorPokemon::Player.new()
    @pokedex = PoorPokemon::Pokedex.new()
  end

  def call
    intro
    difficulty
    pokedexSelection
    beginFight
    declareWinner
    restart
  end
  
  def intro
    puts 'Welcome to Poorly Designed Pokemon Remake (PDPR)!'
    puts 'I\'ve scraped Pokemon and their stats from a website and created a pokedex.'
    puts 'You\'ll battle \'Poorly Designed Boss\', who has the 6 best pokemon with perfect stats!'
    puts 'To battle him, you\'ll select 6 pokemon from the pokedex to add to your roster'
    puts 'Then you\'ll take turns attacking his pokemon with yours.'
    puts 'Unfortunately, \'Poorly Designed Boss\' has sabatoged your pokemon by giving them random attacks and imperfect stats!'
    puts 'Can you still defeat him, despite being at a disadvantage!?'
    puts 'Good luck, and have fun!'
  end
  
  def difficulty
    #Sets difficulty of Enemy AI
    userInput = ""
    choices = ['e','h','easy','hard']
    until choices.include?(userInput) do
      puts "Select Difficulty: (e)asy (h)ard"
      userInput = gets.strip.downcase
    end
    @difficulty = userInput
    if userInput == "e" || userInput == "easy"
      @enemy = PoorPokemon::Enemy.new(@pokedex.randSix(true))
      fillMoves(@enemy, "easy")
    elsif userInput == "h" || userInput == "hard"
      @enemy = PoorPokemon::Enemy.new(@pokedex.bestSix(true))
      fillMoves(@enemy, "hard")
    end
  end

  def fillMoves(char, diff=nil)
    #fills char's pokemon roster with appropriate moves
    #moves are different for enemy
    if char.is_a?(PoorPokemon::Player)
      char.roster.each{|pokemon|
        output = []
        output.push(PoorPokemon::Move.new("Normal Attack",randAtt(45),"Normal",30))
        output.push(PoorPokemon::Move.new("Big Normal Attack",randAtt(110),"Normal",10))
        output.push(PoorPokemon::Move.new("Special Attack",randAtt(70),randType,20))
        output.push(PoorPokemon::Move.new("Big Special Attack",randAtt(100),randType,5))
        pokemon.moves = output
      }
    else
      #Enemy player
      if diff == "easy"
        char.roster.each{|pokemon|
          output = []
          output.push(PoorPokemon::Move.new("Normal Attack",randAtt(45),"Normal",30))
          output.push(PoorPokemon::Move.new("Big Normal Attack",randAtt(110),"Normal",10))
          output.push(PoorPokemon::Move.new("Special Attack",randAtt(70),randType,20))
          output.push(PoorPokemon::Move.new("Big Special Attack",randAtt(100),randType,5))
          pokemon.moves = output
        }
      elsif diff == "hard"
        char.roster.each{|pokemon|
          output=[]
          output.push(PoorPokemon::Move.new("Normal Attack",40,"Normal",30))
          output.push(PoorPokemon::Move.new("Big Normal Attack",100,"Normal",10))
          output.push(PoorPokemon::Move.new("Special Attack",65,pokemon.type1,20))
          output.push(PoorPokemon::Move.new("Big Special Attack",90,pokemon.type1,5))
          pokemon.moves = output
        }
      end
    end

  end

  def randType
      ["Bug","Dragon","Ice","Fighting","Fire","Flying","Grass","Ghost","Ground","Electric","Normal","Poison","Psychic","Rock","Water"].sample
  end

  def randAtt(num)
      var = (num * 0.1).round
      rand(var)+num-var
  end

  def displayPokemon(pokeGroup)
    #pokeGroup is an array of PokedexPokemon
    #must have at least 1 item in array
    #Displays the group for the user
    maxNameLength = pokeGroup.sort{|a,b| a.name.length<=>b.name.length}.last.name.length+5

    pokeGroup.each_index{|i| 
      name = "#{i+1}. #{pokeGroup[i].name.capitalize}"
      until name.length >= maxNameLength do
        name = name + " "
      end
      types = pokeGroup[i].type2 != "" ? pokeGroup[i].type1.capitalize + "+" + pokeGroup[i].type2.capitalize : pokeGroup[i].type1.capitalize
      puts "#{name} TYPE:#{types} HP:#{pokeGroup[i].hp} ATT:#{pokeGroup[i].att} DEF:#{pokeGroup[i].def} SPD:#{pokeGroup[i].spd} SP-ATT:#{pokeGroup[i].spAtt} SP-DEF:#{pokeGroup[i].spDef}"
    }
  end  

  def pokedexSelection
    #player will begin selecting desired pokemon from pokedex
    #Ends when player has full roster
    until @player.roster.length>=6 do
      showPlayerRoster
      playerSelection
    end
    showPlayerRoster
    fillMoves(@player)
  end
  
  def showPlayerRoster
    puts "YOUR ROSTER:"
    if @player.roster.length>0
      @player.roster.each_index{|i|
        puts "#{i+1}. #{@player.roster[i].name.capitalize}"
      }
    else
      puts "{There are no pokemon in your roster}"
    end
    sepLine
  end

  def playerSelection
    userInput = ""
    until ["1","2"].include?(userInput) do
      puts "Select a pokemon from the Pokedex, to add to your roster (#{6-@player.roster.length} left to pick)"
      puts "Options: (1)List all pokemon (2)Search by name"
      userInput = gets.strip
      case userInput
      when "1"
        searchResults = @pokedex.pokeList #full list of pokemon
      when "2"
        searchResults = []
        until searchResults.length>0 do
          puts 'Type in a name or partial name to search: '
          searchInput = gets.strip
          searchResults = @pokedex.searchName(searchInput)
          if searchResults.length<1
            puts "{No results found. Try again.}"
          end
        end
      else
        invalid
      end
    end  
    sepLine
    # Either list all pokemon, or allow for search by name
    displayPokemon(searchResults)
    sepLine
    #User selects pokemon
    validSelection = ""
    until (1..searchResults.length).map{|x| x.to_s}.include?(validSelection) do
      puts "Select the number of the pokemon to add to your roster"
      validSelection=gets.strip
    end
    sepLine
    @player.add(searchResults[validSelection.to_i-1].clone)
  end

  def sepLine
    puts "____________________"
  end

  def invalid
    puts "{Invalid selection. Try again.}"
  end

  def beginFight
    puts "\'Poorly Designed Boss\' wants to battle!"
    displayBothRosters
    playerSwitch
    until @player.allDead? || @enemy.allDead? do
      turnOrder
    end
  end
  
  def displayBothRosters
    maxLength = @player.roster.sort{|a,b| a.name.length<=>b.name.length}.last.name.length+2
    title = "You"
    until title.length >= maxLength do
        title = " " + title
    end
    puts title + " || Enemy"
    sepLine
    @player.roster.each_index{|i|
      text = @player.roster[i].name.upcase
      until text.length >= maxLength do
        text = " " + text
      end
      typeText = @enemy.roster[i].type2!="" ? " (#{@enemy.roster[i].type1.capitalize}+#{@enemy.roster[i].type2.capitalize})" : " (#{@enemy.roster[i].type1.capitalize})"
      text = text + " || " + @enemy.roster[i].name.upcase + typeText
      puts text
    }

  end

  def declareWinner
    if @player.allDead?
      puts "You lost!"
    else
      puts "You won!"
    end
  end

  def turnOrder
    #decides turn order based on each player's current pokemon's speed
    #in event of tie, random
    if @player.currentPokemon.spd == @enemy.currentPokemon.spd
      if rand()>0.5
        playerTurn
        if @enemy.currentPokemon.alive?
          enemyTurn
        end
      else
        enemyTurn
        if @player.currentPokemon.alive?
          playerTurn
        end
      end
    elsif @player.currentPokemon.spd>@enemy.currentPokemon.spd
      playerTurn
      if @enemy.currentPokemon.alive?
        enemyTurn
      end
    elsif @player.currentPokemon.spd<@enemy.currentPokemon.spd
      enemyTurn
      if @player.currentPokemon.alive?
        playerTurn
      end
    end

    #switch if any dead and player still has usable pokemon
    if !@player.currentPokemon.alive?
      puts "Your #{@player.currentPokemon.name.upcase} fainted!"
      if !@player.allDead?
        playerSwitch
      end
    end
    if !@enemy.currentPokemon.alive?
      puts "Enemy #{@enemy.currentPokemon.name.upcase} fainted!"
      if !@enemy.allDead?
        @enemy.switch
        puts "Enemy sent out #{@enemy.currentPokemon.name.upcase}!"
      end
    end

    if !gameWon?
      currentStatus
    end
  end

  def playerTurn
    puts "###Your Turn###"
    typeText = @player.currentPokemon.type2 != "" ? "#{@player.currentPokemon.type1}+#{@player.currentPokemon.type2}" : "#{@player.currentPokemon.type1}"
    puts "Current Pokemon: #{@player.currentPokemon.name.upcase} HP:#{@player.currentPokemon.hp} TYPE: #{typeText.upcase}"
    typeText = @enemy.currentPokemon.type2 != "" ? "#{@enemy.currentPokemon.type1}+#{@enemy.currentPokemon.type2}" : "#{@enemy.currentPokemon.type1}"
    puts "Enemy Pokemon: #{@enemy.currentPokemon.name.upcase} HP:#{@enemy.currentPokemon.hp} TYPE: #{typeText.upcase}"
    sepLine
    puts "What would you like to do? (a)ttack (s)witch"
    userInput = ""
    choices = ["a","attack","s","switch"]
    until choices.include?(userInput) do
      userInput = gets.strip.downcase
      if (userInput == "s" || userInput == "switch")
        playerSwitch
      elsif(userInput == "a" || userInput == "attack")
        playerAttacks(@enemy.currentPokemon)
      else
        invalid
      end
    end
    sepLine
  end

  def playerSwitch
    #Player switches current pokemon from roster
    sepLine
    if @player.currentPokemon
      puts "Select Pokemon from your roster to switch to:"
    else
      puts "Select Pokemon from your roster to start with:"
    end
    userInput = "0"
    until @player.valids.include?(@player.roster[userInput.to_i-1]) && userInput != "0" do
      showPlayerSwitchRoster
      userInput = gets.strip
      if !@player.valids.include?(@player.roster[userInput.to_i-1])
        invalid
      end
    end
    if @player.currentPokemon
      puts "#{@player.currentPokemon.name.upcase} returns!"
    end
    @player.changeCurrent(userInput.to_i-1)
    puts "#{@player.currentPokemon.name.upcase} enters the battle!"
  end

  def showPlayerSwitchRoster
    maxLength = @player.roster.sort{|a,b| a.name.length<=>b.name.length}.last.name.length+5

    @player.roster.each_index{|i|
      health = @player.roster[i].alive? ? @player.roster[i].hp.to_s + " HP" : "FAINTED!"
      text = "#{i+1}. #{@player.roster[i].name.upcase}"
      until text.length >= maxLength do
        text = text + " "
      end
      if health !="FAINTED!"
        puts "#{text}| STATUS: #{health} spAtt1:#{@player.roster[i].moves[2].name.match(/(?<=\().*(?=\))/)[0].upcase}/PP #{@player.roster[i].moves[2].pp}  spAtt2:#{@player.roster[i].moves[3].name.match(/(?<=\().*(?=\))/)[0].upcase}/PP #{@player.roster[i].moves[3].pp}"
      else
        puts "#{text}| STATUS: #{health}"
      end
    }
    sepLine
  end

  def playerAttacks(enemyPokemon)
    #gives user options on what move to attack with
    sepLine
    if @player.currentPokemon.canAttack?
      userInput = "0"
      availMoves = @player.currentPokemon.usableMoves
      until availMoves.include?(@player.currentPokemon.moves[userInput.to_i-1]) && userInput!="0" do
        puts "Which move should #{@player.currentPokemon.name.capitalize} use?"
        maxLength = @player.currentPokemon.moves.sort{|a,b| a.name.length<=>b.name.length}.last.name.length+5
        @player.currentPokemon.moves.each_index{|i|
          move = @player.currentPokemon.moves[i]
          text = "#{i+1}. #{move.name.upcase}"
          until text.length >= maxLength do
            text = text + " "
          end
          puts "#{text} > PP: #{move.pp}"
        }
        userInput = gets.strip
        if !availMoves.include?(@player.currentPokemon.moves[userInput.to_i-1]) && userInput!="0"
          invalid
        end
      end
      move = @player.currentPokemon.moves[userInput.to_i-1]
      puts "#{@player.currentPokemon.name.upcase} used #{move.name.split(" (")[0].upcase} (#{move.type})!"
      puts dmgText(@player.currentPokemon.attacks(enemyPokemon,move))
    else 
      #current pokemon is out of PP for all moves, defaults to "Struggle"
      struggle = PoorPokemon::Move.new("Struggle",40,"Normal",99)
      puts "#{@player.currentPokemon.name.upcase} is out of moves!"
      puts "#{@player.currentPokemon.name.upcase} used STRUGGLE! #{struggle.type}"
      puts dmgText(@player.currentPokemon.attacks(enemyPokemon,struggle))
    end
  end

  def dmgText(dmgArray)
    #depending on the number, will evaluate the effectiveness of the attack
    #returns a string to communicate that effectiveness
    dmg = dmgArray[0]
    num = dmgArray[1]
   
    if num == 0
      output = "No effect!"
    elsif num == 0.5 || num == 0.25
      output = "It's not very effective."
    elsif num == 2
      output = "It's super-effective!"
    elsif num == 4
      output = "Critical hit!" #Not a true critical hit
    else
      output = "It hit!"
    end
    output + " (#{dmg} dmg)"
  end

  def enemyTurn
    puts "###Enemy Turn###"
    if @enemy.currentPokemon.canAttack?
      attackArray = @enemy.attacks(@player.currentPokemon,@difficulty)
      puts "#{@enemy.currentPokemon.name.upcase} used #{attackArray[1].name.split(" (")[0].upcase}  (#{attackArray[1].type})!"
      puts dmgText(attackArray[0])
    else 
      #current pokemon is out of PP for all moves, defaults to "Struggle"
      struggle = PoorPokemon::Move.new("Struggle",40,"Normal",99)
      attackArray = @enemy.attacks(@player.currentPokemon, @difficulty, struggle)
      puts "Enemy #{@enemy.currentPokemon.name.upcase} is out of moves!"
      puts "Enemy #{@enemy.currentPokemon.name.upcase} used STRUGGLE #{struggle.type}!"
      puts dmgText(attackArray[0])
    end
    sepLine
  end

  def currentStatus
    #prints current status for both sides
    sepLine
    puts "###CURRENT STATUS###"
    puts "Your #{@player.currentPokemon.name.upcase} has #{@player.currentPokemon.hp} HP"
    puts "Enemy #{@enemy.currentPokemon.name.upcase} has #{@enemy.currentPokemon.hp} HP"
    sepLine
  end

  def gameWon?
    @enemy.allDead? || @player.allDead?
  end

  def restart
    sepLine
    puts "Would you like to play again? (y)es (n)o"
    choices = ["y","n","yes","no"]
    userInput = ''
    until choices.include?(userInput) do
      userInput = gets.strip.downcase
    end

    if(userInput == "y" || userInput == "yes")
      call
    end
  end
end
