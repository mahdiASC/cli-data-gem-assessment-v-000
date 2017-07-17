# Contains game logic

# Pokedex selection
# Option to just fill roster of 6

# Pokemon from pokedex will be given standard move set and random special

# To Do
# Add player choices
# Add dmg equation
# Make searched pokedex item to addable to roster
# Add local leaderboard
# REPLACE local URL in "pokedex.rb"

####Game logic###
# Game explained with puts
# Player starts with empty roster 
# Until Player has 6 pokemon in roster:
#   Player selects a pokedexPokemon, which are cloned into Player's roster
# Game starts with introduction to enemy team (standard)


require "./pokedex.rb"
require "./enemy.rb"
require "./player.rb"
require './move.rb'

class Game
  attr_accessor :player, :enemy, :pokedex

  def initialize
    @player = Player.new()
    @pokedex = Pokedex.new()
    @enemy = Enemy.new(@pokedex.bestSix.map{|pokedexPokemon| pokedexPokemon.clone})
    fillMoves(@enemy)
  end

  def start
    intro
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
  
  def fillMoves(char)
    #fills char's pokemon roster with appropriate moves
    #moves are different for enemy
    if char.is_a?(Player)
      char.roster.each{|pokemon|
        pokemon.moves.push(Move.new("Normal Attack",randAtt(45),"Normal",30))
        pokemon.moves.push(Move.new("Big Normal Attack",randAtt(110),"Normal",10))
        pokemon.moves.push(Move.new("Special Attack",randAtt(70),randType,20))
        pokemon.moves.push(Move.new("Big Special Attack",randAtt(100),randType,5))
      }
    else
      player.roster.each{|pokemon|
        pokemon.moves.push(Move.new("Normal Attack",40,"Normal",30))
        pokemon.moves.push(Move.new("Big Normal Attack",100,"Normal",10))
        pokemon.moves.push(Move.new("Special Attack",65,pokemon.type1,20))
        pokemon.moves.push(Move.new("Big Special Attack",90,pokemon.type1,5))
      }
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
    puts "\'Poorly Designed Boss\' has appeared!"
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
      text = @player.roster[i].name.capitalize
      until text.length >= maxLength do
        text = " " + text
      end
      text = text + " || " + @enemy.roster.reverse[i].name.capitalize
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
    elsif @player.currentPokemon.spd>@enemy.currentPokemon.spd
      enemyTurn
      if @player.currentPokemon.alive?
        playerTurn
      end
    end
  end

  def playerTurn
    puts "Your turn! Current Pokemon: #{@player.currentPokemon.name} HP:#{@player.currentPokemon.hp}"
    puts "What would you like to do? (a)ttack (s)witch"
    userInput = ""
    choices = ["a","attack","s","switch"]
    until choices.include?(userInput) do
      userInput = gets.strip
      if (userInput == "s" || userInput == "switch")
        playerSwitch
      elsif(userInput == "a" || userInput == "attack")
        playerAttacks(@player.currentPokemon)
      else
        invalid
      end
    end
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
    end
    if @player.currentPokemon
      puts "#{@player.currentPokemon.name.capitalize} returns!"
    end
    @player.changeCurrent(userInput.to_i-1)
    puts "#{@player.currentPokemon.name.capitalize} enters the battle!"
  end

  def showPlayerSwitchRoster
    @player.roster.each_index{|i|
      health = @player.roster[i].alive? ? @player.roster[i].hp.to_s + " HP" : "FAINTED!"
      puts "#{i+1}. #{@player.roster[i].name} STATUS: #{health}"
    }
    sepLine
  end

  def playerAttacks(enemyPokemon)
    #gives user options on what move to attack with
    if @player.currentPokemon.canAttack?
      puts "Which move should #{@player.currentPokemon.name.capitalize} use?"
      userInput = "0"

      until @player.currentPokemon.usableMoves.include?(@player.currentPokemon.moves[userInput.to_i-1]) do
        userInput = gets.strip
        if !@player.currentPokemon.usableMoves.include?(@player.currentPokemon.moves[userInput.to_i-1])
          invalid
        end
      end
      puts "Your #{@player.currentPokemon.name.capitalize} attacks the enemy #{@enemy.currentPokemon.name.capitalize} for #{@player.currentPokemon.attacks(@enemy.currentPokemon,@player.currentPokemon.moves[userInput.to_i-1])} damage!"
    else 
      #current pokemon is out of PP for all moves, defaults to "Struggle"
      struggle = Move.new("Struggle",40,"Normal",99)
      puts "Your #{@player.currentPokemon.name.capitalize} is out of moves! It uses Struggle to attacks the enemy #{@enemy.currentPokemon.name.capitalize} for #{@player.currentPokemon.attacks(@enemy.currentPokemon,struggle)} damage!"
    end
    #then initiates the attack
  end

  def enemyTurn
    @enemy.currentPokemon.attacks(@player.currentPokmeon)
  end

  def restart
    sepLine
    puts "Would you like to play again? (y)es (n)o"
    choices = ["y","n","yes","no"]
    userInput = ''
    until choices.include?(userInput) do
      userInput = gets.strip
    end

    if(userInput == "y" || userInput == "yes")
      start
    end
  end
end
